import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/models/teacher.dart';

class ListDataController extends GetxController {
  List<Students> allStudents = [];
  List<TeacherData> allTeacher = [];
  int displayedItems = 10;
  int teacherItems = 10;

  var studentPage = 1.obs;
  var teacherPage = 1.obs;

  var isLoadingStudent = false.obs;
  var isLoadingTeacher = false.obs;

  @override
  void onInit() {
    loadStudentData();
    loadTeacherData();
    super.onInit();
  }

  Future<void> loadStudentData() async {
    try {
      isLoadingStudent.value = true;

      var response = await http.get(
        Uri.parse(
          'https://backend-shool-project.onrender.com/student/new_list?page=$studentPage&limit=$displayedItems',
        ),
      );

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body)['students'];

        List<Students> listStudent = data.map((e) => Students.fromJson(e)).toList();

        allStudents.addAll(listStudent);

        isLoadingStudent.value = false;
      } else {
        throw Exception('Failed to new list page student');
      }
    } catch (error) {
      print('Lỗi load data student: $error');
      isLoadingStudent.value = false;
    } finally {
      isLoadingStudent.value = false;
    }
  }

  Future<void> loadMoreStudentData() async {
    studentPage.value++;
    await loadStudentData();
  }

  Future<void> loadTeacherData() async {
    try {
      isLoadingTeacher.value = true;
      var response = await http.get(
        Uri.parse(
          'https://backend-shool-project.onrender.com/teacher/total_page?page=$teacherPage&limit=$teacherItems',
        ),
      );

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body)['data'];

        List<TeacherData> listPage = data.map((e) => TeacherData.fromJson(e)).toList();

        allTeacher.addAll(listPage);

        isLoadingTeacher.value = false;
      } else {
        throw Exception('Failed to page teacher');
      }
    } catch (error) {
      print('Lỗi get data teacher: $error');
      isLoadingTeacher.value = false;
    } finally {
      isLoadingTeacher.value = false;
    }
  }

  Future<void> loadMoreTeacherData() async {
    teacherPage.value++;
    await loadTeacherData();
  }
}
