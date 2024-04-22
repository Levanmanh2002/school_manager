import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/routes/pages.dart';
import 'package:school_web/web/utils/status/status.dart';

class AuthController extends GetxController {
  RxString token = ''.obs;

  var selectedProvince = ''.obs;
  var selectedDistrict = ''.obs;
  var selectedWard = ''.obs;

  var provinces = <String>[].obs;
  var districts = <String>[].obs;
  var wards = <String>[].obs;

  Map<String, dynamic> addressData = {};

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  void setToken(String newToken) {
    token.value = newToken;
  }

  var username = ''.obs;
  var password = ''.obs;
  var rememberMe = false.obs;

  var isUpdateLoading = false.obs;

  final Rx<TeacherData?> teacherData = Rx<TeacherData?>(null);

  void updateUsername(String value) {
    username.value = value;
  }

  void updatePassword(String value) {
    password.value = value;
  }

  void toggleRememberMe(bool value) {
    rememberMe.value = value;
  }

  Future<dynamic> getProfileData() async {
    final token = await const FlutterSecureStorage().read(key: 'token');

    var headers = {'Authorization': 'Bearer $token'};
    var request = http.Request('GET', Uri.parse('https://backend-shool-project.onrender.com/admin/profile'));
    request.body = '''''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      final jsonData = await response.stream.bytesToString();
      final teacher = Teacher.fromJson(json.decode(jsonData));

      teacherData.value = teacher.data;
    } else {
      print(response.reasonPhrase);
      logout();
    }
  }

  Future<dynamic> getPutProfileTeacher(
    String teacherId, {
    required String fullName,
    required String email,
    required String phoneNumber,
    required String gender,
    required String cccd,
    required String birthDate,
    required String ethnicity,
    required String experience,
    required String joinDate,
    required bool isWorking,
    required String address,
  }) async {
    try {
      isUpdateLoading(true);

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'PUT',
        Uri.parse('https://backend-shool-project.onrender.com/admin/update/teacher/$teacherId'),
      );
      request.body = json.encode({
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "cccd": cccd,
        "birthDate": birthDate,
        "ethnicity": ethnicity,
        "experience": experience,
        "joinDate": joinDate,
        "isWorking": isWorking,
        "address": address,
        "city": selectedProvince.toString(),
        "district": selectedDistrict == ' ' ? '' : selectedDistrict.toString(),
        "ward": selectedWard.toString(),
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final res = await json.decode(await response.stream.bytesToString());

      print(request.body);
      print(res['status']);

      if (res['status'] == 'check_email') {
        showErrorStatus('Email đã tồn tại');

        isUpdateLoading(false);
      } else if (res['status'] == 'check_phone') {
        showErrorStatus('Số điện thoại đã tồn tại');

        isUpdateLoading(false);
      } else if (res['status'] == 'check_cccd') {
        showErrorStatus('CCCD đã tồn tại');

        isUpdateLoading(false);
      } else if (res['status'] == 'SUCCESS') {
        final jsonData = await response.stream.bytesToString();
        final teacher = Teacher.fromJson(json.decode(jsonData));

        teacherData.value = teacher.data;

        Get.back();
        showSuccessStatus('Cập nhật tài khoản thành công');
        loadData();

        isUpdateLoading(false);
      } else {
        showErrorStatus('Lỗi kết nối!');

        isUpdateLoading(false);
      }
    } catch (e) {
      print("Lỗi update profile techer: $e");
      isUpdateLoading(false);
    } finally {
      isUpdateLoading(false);
    }
  }

  Future<void> uploadAvatarTeacher(String teacherId, {required String filePath}) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://backend-shool-project.onrender.com/admin/upload-avatar-teacher'),
      );

      request.fields.addAll({'teacherId': teacherId});
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          filePath,
        ),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        showSuccessStatus('Cập nhật ảnh đại diện thành công');

        await getProfileData();
      } else {
        showFailStatus('Cập nhật ảnh đại diện thất bại');
      }
    } catch (error) {
      print('Lỗi upload avatar teacher: $error');
    }
  }

  Future<void> updateBackgroundImageUrl(String teacherId, {required String filePath}) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://backend-shool-project.onrender.com/admin/upload-background-teacher'),
      );

      request.fields.addAll({'teacherId': teacherId});
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          filePath,
        ),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        showSuccessStatus('Cập nhật ảnh bìa thành công');

        await getProfileData();
      } else {
        showFailStatus('Cập nhật ảnh bìa thất bại');
      }
    } catch (error) {
      print('Lỗi update background image url: $error');
    }
  }

  Future<void> loadData() async {
    String jsonString = await rootBundle.loadString('assets/new_index.json');
    Map<String, dynamic> data = jsonDecode(jsonString);

    List<String> provinceCodes = data.keys.toList();

    provinces.assignAll(provinceCodes);

    data.forEach((key, value) {
      addressData[key] = value;
    });

    selectProvince(provinceCodes.isNotEmpty ? provinceCodes.first : '');
  }

  void selectProvince(String provinceCode) async {
    print('Selected province: $provinceCode');

    selectedProvince.value = provinceCode;

    String jsonFilePath = 'assets${addressData[provinceCode]['file_path']}';
    String jsonString = await rootBundle.loadString(jsonFilePath);
    Map<String, dynamic> provinceData = jsonDecode(jsonString);

    List<dynamic> districtData = provinceData['district'];
    List<String> districtNames =
        districtData.map((item) => '${item['pre'].toString()} ${item['name'].toString()}').toList();

    districts.assignAll(districtNames);

    selectDistrict(districtNames.isNotEmpty ? districtNames.first : '');
  }

  void selectDistrict(String districtName) async {
    print('Selected district: $districtName');

    selectedDistrict.value = districtName;

    String jsonFilePath = 'assets${addressData[selectedProvince.value]['file_path']}';
    String jsonString = await rootBundle.loadString(jsonFilePath);
    Map<String, dynamic> provinceData = jsonDecode(jsonString);

    Map<String, dynamic> districtWithPre = provinceData['district'].firstWhere(
      (item) => '${item['pre'].toString()} ${item['name'].toString()}' == districtName,
    );

    List<dynamic> wardData = districtWithPre['ward'];
    List<String> wardNames = wardData.map((item) => '${item['pre'].toString()} ${item['name'].toString()}').toList();

    wards.assignAll(wardNames);

    selectWard(wards.isNotEmpty ? wards.first : '');
  }

  void selectWard(String wardName) {
    print('Selected ward: $wardName');

    selectedWard.value = wardName;
  }

  Future<void> logout() async {
    await const FlutterSecureStorage().delete(key: 'token');
    await Get.offAllNamed(Routes.SIGNIN);
  }
}
