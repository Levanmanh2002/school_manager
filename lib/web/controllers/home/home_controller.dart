// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final _totalTeacher = 0.obs;
  final _totalRetiredTeachers = 0.obs;
  final _totalWorkingTeachers = 0.obs;
  final _totalClass = 0.obs;
  final _totalNewStudent = 0.obs;

  final _totalAll = 0.obs;
  final _totalActiveStudents = 0.obs;
  final _totalSelfSuspendedStudents = 0.obs;
  final _totalSuspendedStudents = 0.obs;
  final _totalExpelledStudents = 0.obs;

  int get totalTeacher => _totalTeacher.value;
  int get totalRetiredTeachers => _totalRetiredTeachers.value;
  int get totalWorkingTeachers => _totalWorkingTeachers.value;
  int get totalClass => _totalClass.value;
  int get totalNewStudent => _totalNewStudent.value;

  // Lấy tất cả danh sách học sinh
  int get totalAll => _totalAll.value;
  // Lấy danh sách học sinh đang học
  int get activeStudents => _totalActiveStudents.value;
  // Lấy danh sách học sinh tự nghỉ học
  int get selfSuspendedStudents => _totalSelfSuspendedStudents.value;
  //Lấy danh sách học sinh đang bị đình chỉ học
  int get suspendedStudents => _totalSuspendedStudents.value;
  // Lấy danh sách học sinh bị đuổi học
  int get expelledStudents => _totalExpelledStudents.value;

  @override
  void onInit() {
    super.onInit();
    totalTeacherData();
    totalRetiredTeacherData();
    totalWorkingTeacherData();
    totalClassData();
    totalNewStudentData();
    fetchAllStudentData();
    fetchActiveStudents();
    fetchSelfSuspendedStudents();
    fetchSuspendedStudents();
    fetchExpelledStudents();
  }

  Future<void> totalTeacherData() async {
    try {
      var url = Uri.parse('https://backend-shool-project.onrender.com/routes/total_teacher');
      var response = await http.get(url);

      if (response.statusCode == 201) {
        var result = json.decode(response.body);

        _totalTeacher.value = result['total'];
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> totalRetiredTeacherData() async {
    try {
      var url = Uri.parse('https://backend-shool-project.onrender.com/admin/retired-teachers');
      var response = await http.get(url);

      if (response.statusCode == 201) {
        var result = json.decode(response.body);

        _totalRetiredTeachers.value = result['total'];
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> totalWorkingTeacherData() async {
    try {
      var url = Uri.parse('https://backend-shool-project.onrender.com/admin/working-teachers');
      var response = await http.get(url);

      if (response.statusCode == 201) {
        var result = json.decode(response.body);

        _totalWorkingTeachers.value = result['total'];
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> totalClassData() async {
    try {
      var url = Uri.parse('https://backend-shool-project.onrender.com/routes/total_class');
      var response = await http.get(url);

      if (response.statusCode == 201) {
        var result = json.decode(response.body);

        _totalClass.value = result['total'];
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> totalNewStudentData() async {
    try {
      var url = Uri.parse('https://backend-shool-project.onrender.com/routes/total_new_student');
      var response = await http.get(url);

      if (response.statusCode == 201) {
        var result = json.decode(response.body);

        _totalNewStudent.value = result['total'];
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchAllStudentData() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/data/all-students'));

      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        _totalAll.value = result['total'];
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchActiveStudents() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/data/active-students'));

      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        _totalActiveStudents.value = result['total'];
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchSelfSuspendedStudents() async {
    try {
      var response = await http.get(
        Uri.parse('https://backend-shool-project.onrender.com/data/self-suspended-students'),
      );

      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        _totalSelfSuspendedStudents.value = result['total'];
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchSuspendedStudents() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/data/suspended-students'));

      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        _totalSuspendedStudents.value = result['total'];
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchExpelledStudents() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/data/expelled-students'));

      if (response.statusCode == 200) {
        var result = json.decode(response.body);

        _totalExpelledStudents.value = result['total'];
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
