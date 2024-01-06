// ignore_for_file: unnecessary_type_check

import 'dart:convert';

import 'package:get/get.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:http/http.dart' as http;

class TeacherController extends GetxController {
  Future<List<TeacherData>> fetchWorkingTeachers() async {
    final response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/working-teachers'));
    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];

      // if (data is List) {
      List<TeacherData> teachers = data.map((teacherData) => TeacherData.fromJson(teacherData)).toList();
      // teachers.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
      return teachers;
      // } else {
      // throw Exception('Invalid data format');
      // }
    } else {
      throw Exception('Failed to load working teachers');
    }
  }

  Future<List<TeacherData>> fetchRetiredTeachers() async {
    final response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/retired-teachers'));
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
      throw Exception('Failed to load retired teachers');
    }
  }
}
