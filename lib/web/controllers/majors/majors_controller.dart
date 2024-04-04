import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/main.dart';
import 'package:school_web/web/models/majors_models.dart';
import 'package:school_web/web/utils/status/status.dart';

class MajorsController extends GetxController {
  var majorsList = <MajorsData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMajors();
  }

  Future<void> fetchMajors() async {
    try {
      final response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/majors'));

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body)['data'];

        majorsList.assignAll(data.map((e) => MajorsData.fromJson(e)).toList());
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Lỗi get major: $error');
    }
  }

  Future<dynamic> addMajors({required String nameController, required String desController}) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('https://backend-shool-project.onrender.com/admin/add-major'));
      request.body = json.encode({"name": nameController, "description": desController});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        fetchMajors();

        showSuccessStatus('Ngành nghề mới đã được thêm thành công');
      } else {
        Get.snackbar(
          "Thất bại",
          "Thêm mới ngành nghề thất bại.",
          backgroundColor: appTheme.errorColor,
          colorText: appTheme.whiteColor,
        );

        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Lỗi add majors: $error');
    }
  }

  Future<void> onEditMajors(String id, {required String nameEditController, required String desEditController}) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('PUT', Uri.parse('https://backend-shool-project.onrender.com/admin/edit-major/$id'));
      request.body = json.encode({"name": nameEditController, "description": desEditController});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        fetchMajors();

        showSuccessStatus('Ngành nghề đã được chỉnh sửa');
      } else if (response.statusCode == 400) {
        showErrorStatus('Ngành nghề đã tồn tại');
      } else {
        showFailStatus('Chỉnh sửa ngành nghề thất bại');
      }
    } catch (error) {
      print('Lỗi edit majors: $error');
    }
  }

  Future<dynamic> onDeleteMajors(String id) async {
    try {
      var request = http.Request(
        'DELETE',
        Uri.parse('https://backend-shool-project.onrender.com/admin/delete-major/$id'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        fetchMajors();
        showSuccessStatus('Ngành nghề đã được xóa');
      } else {
        showErrorStatus('Lỗi xóa ngành nghề');
      }
    } catch (error) {
      print('Lỗi delete major: $error');
    }
  }
}
