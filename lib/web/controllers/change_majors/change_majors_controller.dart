import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/utils/status/status.dart';

class ChangeMajorsController extends GetxController {
  var isLoadingSearch = false.obs;
  var isLoadingBtn = false.obs;

  var studentList = <Students>[].obs;

  Future<void> searchStudent(String searchQuery) async {
    try {
      isLoadingSearch(true);
      var response = await http.post(
        Uri.parse('https://backend-shool-project.onrender.com/search/mssv?searchQuery=$searchQuery'),
      );

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body)['data'];

        studentList.assignAll(data.map((e) => Students.fromJson(e)).toList());

        isLoadingSearch(false);
      } else {
        isLoadingSearch(false);
      }
    } catch (error) {
      print('Lỗi search student: $error');
      isLoadingSearch(false);
    } finally {
      isLoadingSearch(false);
    }
  }

  Future<void> changeMajor({required String studentId, required String newMajorId}) async {
    try {
      isLoadingBtn(true);

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('PUT', Uri.parse('https://backend-shool-project.onrender.com/admin/change_major'));

      request.body = json.encode({"studentId": studentId, "newMajorId": newMajorId});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final res = await json.decode(await response.stream.bytesToString());

      if (response.statusCode == 201 && res['status'] == 'SUCCESS') {
        showSuccessStatus('Chuyển ngành thành công');
        studentList.clear();
        isLoadingBtn(false);
      } else if (res['status'] == 'invalid_major') {
        showErrorStatus('Chuyên ngành được cung cấp không hợp lệ');
        isLoadingBtn(false);
      } else if (res['status'] == 'student_not_found') {
        showFailStatus('Không tìm thấy sinh viên');
        isLoadingBtn(false);
      }
    } catch (error) {
      print('Lỗi change major: $error');
      isLoadingBtn(false);
    } finally {
      isLoadingBtn(false);
    }
  }
}
