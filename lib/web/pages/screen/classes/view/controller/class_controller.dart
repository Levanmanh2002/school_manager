// Import the get package
import 'dart:convert';

import 'package:get/get.dart';
import 'package:school_web/web/models/classes.dart';
import 'package:http/http.dart' as http;

class ClassesController extends GetxController {
  var classesList = <ClassInfoData>[].obs;

  Future<void> getClassInfo() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/class-info'));

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body)['classInfo'];

        classesList.assignAll(data.map((e) => ClassInfoData.fromJson(e)).toList());
      } else {
        throw Exception('Failed to load classes info');
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getClassInfo();
  }
}
