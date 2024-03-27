// ignore_for_file: unnecessary_type_check

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/controllers/auth_controller.dart';
import 'package:school_web/web/controllers/home/home_controller.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/utils/flash/toast.dart';

class TeacherController extends GetxController {
  final HomeController homeController = Get.put(HomeController());
  final AuthController authController = Get.put(AuthController());

  final isLoading = false.obs;
  final isEditLoading = false.obs;

  var alllTeachers = <TeacherData>[].obs;
  var workingTeachers = <TeacherData>[].obs;
  var retiredTeachers = <TeacherData>[].obs;
  List<TeacherData> filteredTeachers = <TeacherData>[].obs;
  List<TeacherData> filteredRetiredTeachers = <TeacherData>[].obs;
  List<TeacherData> filteredAllTeachers = <TeacherData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllTeachers();
    fetchWorkingTeachers();
    fetchRetiredTeachers();
  }

  Future<void> fetchAllTeachers() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/teacher/total'));

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body)['data'];

        List<TeacherData> fetchedTeachers = data.map((teacherJson) => TeacherData.fromJson(teacherJson)).toList();

        alllTeachers.addAll(fetchedTeachers);

        filteredAllTeachers.addAll(fetchedTeachers);
      } else {
        print('Failed to load teachers: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Failed to load teachers: $error');
    }
  }

  Future<void> fetchWorkingTeachers() async {
    try {
      final response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/working-teachers'));
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];

        if (data is List) {
          List<TeacherData> teachers = data.map((teacherData) => TeacherData.fromJson(teacherData)).toList();
          teachers.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

          workingTeachers.assignAll(teachers);

          filteredTeachers.assignAll(teachers);
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load working teachers');
      }
    } catch (error) {
      print('Error fetching retired teachers: $error');
    }
  }

  Future<void> fetchRetiredTeachers() async {
    try {
      final response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/retired-teachers'));
      if (response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        if (data is List) {
          List<TeacherData> teachers = data.map((teacherData) => TeacherData.fromJson(teacherData)).toList();
          teachers.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

          retiredTeachers.assignAll(teachers.reversed);

          filteredRetiredTeachers.assignAll(teachers.reversed);
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load retired teachers');
      }
    } catch (error) {
      print('Error fetching retired teachers: $error');
    }
  }

  Future<void> searchTeachers(String searchText) async {
    filteredTeachers.clear();
    filteredRetiredTeachers.clear();

    for (TeacherData teacher in workingTeachers) {
      if (teacher.teacherCode?.toLowerCase().contains(searchText.toLowerCase()) == true ||
          teacher.fullName?.toLowerCase().contains(searchText.toLowerCase()) == true ||
          teacher.email?.toLowerCase().contains(searchText.toLowerCase()) == true) {
        filteredTeachers.add(teacher);
      }
    }
    for (TeacherData teacher in retiredTeachers) {
      if (teacher.teacherCode?.toLowerCase().contains(searchText.toLowerCase()) == true ||
          teacher.fullName?.toLowerCase().contains(searchText.toLowerCase()) == true ||
          teacher.email?.toLowerCase().contains(searchText.toLowerCase()) == true) {
        filteredRetiredTeachers.add(teacher);
      }
    }
  }

  Future<void> searchAllTeachers(String searchText) async {
    filteredAllTeachers.clear();

    for (TeacherData teacher in alllTeachers) {
      if (teacher.teacherCode?.toLowerCase().contains(searchText.toLowerCase()) == true ||
          teacher.fullName?.toLowerCase().contains(searchText.toLowerCase()) == true ||
          teacher.email?.toLowerCase().contains(searchText.toLowerCase()) == true) {
        filteredAllTeachers.add(teacher);
      }
    }
  }

  Future<dynamic> addTeacher({
    required String fullName,
    required String teacherCode,
    required String email,
    required String password,
    required String phoneNumber,
    required String gender,
    required String cccd,
    required String birthDate,
    required String birthPlace,
    required String ethnicity,
    required String nickname,
    required String teachingLevel,
    required String position,
    required String experience,
    required String department,
    required String role,
    required String joinDate,
    required String contractType,
    required String primarySubject,
    required String secondarySubject,
    required String academicDegree,
    required String standardDegree,
    required String politicalTheory,
    required String address,
    required String city,
    required String district,
    required String ward,
  }) async {
    try {
      isLoading(true);

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('https://backend-shool-project.onrender.com/admin/add'));
      request.body = json.encode({
        "fullName": fullName,
        "teacherCode": teacherCode,
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
        "gender": gender,
        "cccd": cccd,
        "birthDate": birthDate,
        "birthPlace": birthPlace,
        "ethnicity": ethnicity,
        "nickname": nickname,
        "teachingLevel": teachingLevel,
        "position": position,
        "experience": experience,
        "department": department,
        "role": role,
        "joinDate": joinDate,
        "contractType": contractType,
        "primarySubject": primarySubject,
        "secondarySubject": secondarySubject,
        "academicDegree": academicDegree,
        "standardDegree": standardDegree,
        "politicalTheory": politicalTheory,
        "address": address,
        "city": city,
        "district": district,
        "ward": ward,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final res = await json.decode(await response.stream.bytesToString());

      if (res['status'] == 'email_check') {
        showSimpleIconsToast('Email đã tồn tại');

        isLoading(false);
      } else if (res['status'] == 'phone_check') {
        showSimpleIconsToast('Số điện thoại đã tồn tại');

        isLoading(false);
      } else if (res['status'] == 'code_check') {
        showSimpleIconsToast('Mã giáo viên đã tồn tại');

        isLoading(false);
      } else if (res['status'] == 'cccd_check') {
        showSimpleIconsToast('CCCD đã tồn tại');

        isLoading(false);
      } else if (res['status'] == 'SUCCESS') {
        showSimpleToast('Giáo viên đã được thêm thành công');

        homeController.totalWorkingTeacherData();
        fetchWorkingTeachers();
        authController.loadData();

        Get.back();
        isLoading(false);
      } else {
        showSimpleIconsToast('Lỗi kết nối!');

        isLoading(false);
      }
    } catch (error) {
      print('Lỗi add teacher: $error');
    } finally {
      isLoading(false);
    }
  }

  Future<dynamic> editTeacher(
    String teacherId, {
    required String fullName,
    required String email,
    required String phoneNumber,
    required String gender,
    required String cccd,
    required String birthDate,
    required String birthPlace,
    required String ethnicity,
    required String position,
    required String experience,
    required String joinDate,
    required String contractType,
    required String academicDegree,
    required String address,
    required String city,
    required String district,
    required String ward,
  }) async {
    try {
      isEditLoading(true);

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
        "birthPlace": birthPlace,
        "ethnicity": ethnicity,
        "position": position,
        "experience": experience,
        "joinDate": joinDate,
        "contractType": contractType,
        "academicDegree": academicDegree,
        "address": address,
        "city": city,
        "district": district,
        "ward": ward,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final res = await json.decode(await response.stream.bytesToString());

      if (res['status'] == 'check_email') {
        showSimpleIconsToast('Email đã tồn tại');

        isEditLoading(false);
      } else if (res['status'] == 'check_phone') {
        showSimpleIconsToast('Số điện thoại đã tồn tại');

        isEditLoading(false);
      } else if (res['status'] == 'check_cccd') {
        showSimpleIconsToast('CCCD đã tồn tại');

        isEditLoading(false);
      } else if (res['status'] == 'SUCCESS') {
        showSimpleToast('Giáo viên đã được chỉnh sửa thành công');

        homeController.totalWorkingTeacherData();
        fetchWorkingTeachers();
        authController.loadData();

        Get.back();
        isEditLoading(false);
      } else {
        showSimpleIconsToast('Lỗi kết nối!');

        isEditLoading(false);
      }
    } catch (error) {
      print('Lỗi add teacher: $error');
    } finally {
      isEditLoading(false);
    }
  }
}
