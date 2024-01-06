// ignore_for_file: unnecessary_type_check

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/models/student.dart';

class StudentCtl extends GetxController {
  // Danh sách học sinh đang học
  Future<List<StudentData>> getActiveStudent() async {
    var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/students/active'));

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];

      if (data is List) {
        List<StudentData> student = data.map((studentData) => StudentData.fromJson(studentData)).toList();
        student.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

        return student = student.reversed.toList();
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to load working student');
    }
  }

  // Danh sách học sinh đã nghỉ học
  Future<List<StudentData>> getInactiveStudent() async {
    var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/students/inactive'));

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];

      if (data is List) {
        List<StudentData> student = data.map((studentData) => StudentData.fromJson(studentData)).toList();
        student.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

        return student = student.reversed.toList();
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to load working student');
    }
  }

  // Danh sách học sinh đang bị đình chỉ
  Future<List<StudentData>> getSuspendedStudent() async {
    var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/students/suspended'));

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];

      if (data is List) {
        List<StudentData> student = data.map((studentData) => StudentData.fromJson(studentData)).toList();
        student.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

        return student = student.reversed.toList();
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to load working student');
    }
  }

  // Danh sách học sinh bị đuổi học
  Future<List<StudentData>> getExpelledStudent() async {
    var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/students/expelled'));

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];

      if (data is List) {
        List<StudentData> student = data.map((studentData) => StudentData.fromJson(studentData)).toList();
        student.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

        return student = student.reversed.toList();
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to load working student');
    }
  }
}
