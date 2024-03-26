// ignore_for_file: unnecessary_type_check

import 'dart:convert';

import 'package:get/get.dart';
import 'package:school_web/web/models/classes.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:http/http.dart' as http;

class Controller extends GetxController {
  List<Students> allStudents = [];
  List<TeacherData> allTeacher = [];
  int displayedItems = 10;
  int teacherItems = 10;
  int currentPage = 1;
  int teacherPage = 1;

  Future<List<TeacherData>> getWorkingTeachers() async {
    final response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/working-teachers'));
    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];

      if (data is List) {
        List<TeacherData> teachers = data.map((teacherData) => TeacherData.fromJson(teacherData)).toList();
        teachers.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

        return teachers = teachers.reversed.toList();
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to load working teachers');
    }
  }

  Future<List<Classes>> getClassInfo() async {
    var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/classes'));

    if (response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body)['classes'];

      List<Classes> classes = data.map((e) => Classes.fromJson(e)).toList();

      return classes;
    } else {
      throw Exception('Failed to load classes info');
    }
  }

  Future<List<TeacherData>> getTotalTeacher() async {
    var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/teacher/total'));

    if (response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body)['data'];

      List<TeacherData> total = data.map((e) => TeacherData.fromJson(e)).toList();

      return total;
    } else {
      throw Exception('Failed to total teacher');
    }
  }

  Future<List<TeacherData>> getTotalPageTeacher() async {
    var response = await http.get(
      Uri.parse(
        'https://backend-shool-project.onrender.com/teacher/total_page?page=$teacherPage&limit=$teacherItems',
      ),
    );

    if (response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body)['data'];

      List<TeacherData> listPage = data.map((e) => TeacherData.fromJson(e)).toList();

      return listPage;
    } else {
      throw Exception('Failed to page teacher');
    }
  }

  Future<List<TeacherData>> getNextBatchOfTeacher() async {
    teacherPage++;
    List<TeacherData> nextBatch = await getTotalPageTeacher();
    allTeacher.addAll(nextBatch);
    return List.of(allTeacher);
  }

  Future<List<Students>> getTotalNewListStudent() async {
    var response = await http.get(
      Uri.parse('https://backend-shool-project.onrender.com/student/total_new_list'),
    );

    if (response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body)['students'];

      List<Students> list = data.map((e) => Students.fromJson(e)).toList();

      return list;
    } else {
      throw Exception('Failed to total new list student');
    }
  }

  Future<List<Students>> getNewListStudent() async {
    var response = await http.get(
      Uri.parse('https://backend-shool-project.onrender.com/student/new_list?page=$currentPage&limit=$displayedItems'),
    );

    if (response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body)['students'];

      List<Students> list = data.map((e) => Students.fromJson(e)).toList();

      return list;
    } else {
      throw Exception('Failed to new list page student');
    }
  }

  Future<List<Students>> getNextBatchOfStudents() async {
    currentPage++;
    List<Students> nextBatch = await getNewListStudent();
    allStudents.addAll(nextBatch);
    return List.of(allStudents);
  }

  Future<List<TeacherData>> getRetiredTeachers() async {
    var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/retired-teachers'));

    if (response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body)['data'];

      List<TeacherData> total = data.map((e) => TeacherData.fromJson(e)).toList();

      return total;
    } else {
      throw Exception('Failed to total teacher');
    }
  }
}
