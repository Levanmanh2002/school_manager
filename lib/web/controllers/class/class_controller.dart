// Import the get package
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/main.dart';
import 'package:school_web/web/models/classes.dart';
import 'package:school_web/web/models/majors_models.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/models/teacher.dart';

class ClassesController extends GetxController {
  var classesList = <ClassInfoData>[].obs;
  var filteredClassList = <ClassInfoData>[].obs;
  var studentList = <Students>[].obs;
  var teachers = <TeacherData>[].obs;
  var listMajors = <MajorsData>[].obs;

  var isLoading = false.obs;
  var isLoadingEdit = false.obs;

  final selectedStudents = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getClassInfo();
    fetchStudentWithoutClass();
    getTeacherList();
    fetchMajors();
  }

  Future<void> getClassInfo() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/class-info'));

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body)['classInfo'];

        classesList.assignAll(data.map((e) => ClassInfoData.fromJson(e)).toList());
        filteredClassList.assignAll(classesList);
      } else {
        throw Exception('Failed to load classes info');
      }
    } catch (e) {
      print('Error class: $e');
    }
  }

  Future<void> addClass(TextEditingController createClassController) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('https://backend-shool-project.onrender.com/admin/create-class'));
      request.body = json.encode({"className": createClassController.text});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        Get.snackbar(
          "Thành công",
          "Lớp học mới đã được tạo",
          backgroundColor: appTheme.successColor,
          colorText: appTheme.whiteColor,
        );
        createClassController.clear();
        await getClassInfo();
      } else if (response.statusCode == 400) {
        Get.snackbar(
          "Thất bại",
          "Lớp học đã tồn tại!",
          backgroundColor: appTheme.errorColor,
          colorText: appTheme.whiteColor,
        );
      }
    } catch (e) {
      print('Create class + $e');
    }
  }

  Future<void> editClass(
    String id, {
    required String updatedClassName,
    required String updatedTeacherId,
    required String updatedJob,
    required List<String> updatedStudentIds,
  }) async {
    try {
      isLoadingEdit(true);

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'PUT',
        Uri.parse('https://backend-shool-project.onrender.com/admin/edit-class/$id'),
      );
      request.body = json.encode({
        "updatedClassName": updatedClassName,
        "updatedTeacherId": updatedTeacherId,
        "updatedJob": updatedJob,
        "updatedStudentIds": updatedStudentIds,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        await getClassInfo();

        Get.back();

        Get.snackbar(
          "Thành công",
          "Lớp học đã được chỉnh sửa",
          backgroundColor: appTheme.successColor,
          colorText: appTheme.whiteColor,
        );
        isLoadingEdit(false);
      } else if (response.statusCode == 404) {
        Get.snackbar(
          "Thất bại",
          "Lớp học không tồn tại!",
          backgroundColor: appTheme.errorColor,
          colorText: appTheme.whiteColor,
        );
        isLoadingEdit(false);
      }
    } catch (e) {
      print('Edit class + $e');
      isLoadingEdit(false);
    } finally {
      isLoadingEdit(false);
    }
  }

  Future<void> deleteClass(String id, BuildContext context) async {
    try {
      showLoadingIndicator(context);

      var request = http.Request(
        'DELETE',
        Uri.parse('https://backend-shool-project.onrender.com/admin/delete-class/$id'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        Get.back();

        filteredClassList.removeWhere((element) => element.id == id);
        classesList.removeWhere((element) => element.id == id);

        Get.snackbar(
          "Thành công",
          "Lớp học đã được xóa",
          backgroundColor: appTheme.successColor,
          colorText: appTheme.whiteColor,
        );
      } else if (response.statusCode == 404) {
        Get.snackbar(
          "Thất bại",
          "Lớp học không tồn tại!",
          backgroundColor: appTheme.errorColor,
          colorText: appTheme.whiteColor,
        );
      }
    } catch (e) {
      print('Delete class: $e');
    }
  }

  Future<void> fetchStudentWithoutClass() async {
    try {
      var response = await http.get(
        Uri.parse('https://backend-shool-project.onrender.com/admin/students-without-class'),
      );

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body)['studentsWithoutClass'];

        studentList.assignAll(data.map((e) => Students.fromJson(e)).toList());
      } else {
        throw Exception('Failed student without class');
      }
    } catch (error) {
      print('Student without class: $error');
    }
  }

  Future<void> getTeacherList() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/teacher/total'));

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body)['data'];

        List<TeacherData> fetchedTeachers = data.map((teacherJson) => TeacherData.fromJson(teacherJson)).toList();

        teachers.addAll(fetchedTeachers);
      } else {
        print('Failed to load teachers: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Failed to load teachers: $error');
    }
  }

  Future<void> createListClass(
    BuildContext context, {
    required String className,
    required String teacherId,
    required List<String> studentIds,
    required String job,
  }) async {
    try {
      isLoading(true);

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://backend-shool-project.onrender.com/admin/create-list-student-and-teacher-class'),
      );
      request.body = json.encode({
        "className": className,
        "teacherId": teacherId,
        "studentIds": studentIds,
        "job": job,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        getClassInfo();

        Get.back();

        Get.snackbar(
          "Thành công",
          "Khởi tạo thành công!",
          backgroundColor: appTheme.successColor,
          colorText: appTheme.whiteColor,
        );
      } else {
        Get.snackbar(
          "Lỗi",
          "Khởi tạo thất bại.",
          backgroundColor: appTheme.errorColor,
          colorText: appTheme.whiteColor,
        );
        print(response.reasonPhrase);
      }
      isLoading(false);
    } catch (error) {
      print('Create list student and teacher class: $error');
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchMajors() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/majors'));

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body)['data'];

        listMajors.assignAll(data.map((e) => MajorsData.fromJson(e)).toList());
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error list majors: $error');
    }
  }

  Future<void> removeStudentFromClass({required String classId, required String studentId}) async {
    try {
      var response = await http.delete(
        Uri.parse('https://backend-shool-project.onrender.com/admin/remove-student-from-class/$classId/$studentId'),
      );

      if (response.statusCode == 201) {
        await getClassInfo();

        Get.snackbar(
          "Thành công",
          "Xóa học sinh khỏi lớp học thành công!",
          backgroundColor: appTheme.successColor,
          colorText: appTheme.whiteColor,
        );
      } else {
        Get.snackbar(
          "Thất bại",
          "Xóa học sinh khỏi lớp học thất bại!",
          backgroundColor: appTheme.successColor,
          colorText: appTheme.whiteColor,
        );

        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error remove student from class: $error');
    }
  }

  void showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void searchClass(String query) {
    if (query.isEmpty) {
      filteredClassList.assignAll(classesList);
    } else {
      final lowerCaseQuery = query.toLowerCase();

      filteredClassList.assignAll(
        classesList.where((fee) => fee.className!.toLowerCase().contains(lowerCaseQuery)).toList(),
      );
    }
  }

  void toggleStudentSelection(String studentId) {
    if (selectedStudents.contains(studentId)) {
      selectedStudents.remove(studentId);
    } else {
      selectedStudents.add(studentId);
    }
  }
}
