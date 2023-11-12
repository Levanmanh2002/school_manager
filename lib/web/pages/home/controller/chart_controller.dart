import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChartController extends GetxController {
  RxInt numberOfActiveStudents = 0.obs;
  RxInt numberOfInactiveStudents = 0.obs;
  RxInt numberOfSuspendedStudents = 0.obs;
  RxInt numberOfExpelledStudents = 0.obs;

  Future<void> fetchNumberActiveData() async {
    try {
      var response = await http.get(
        Uri.parse('https://backend-shool-project.onrender.com/chart/students/number_active'),
      );

      if (response.statusCode == 201) {
        final data = response.body;
        final decodedData = json.decode(data);
        final parsedData = decodedData['data'] as int?;

        if (parsedData != null) {
          numberOfActiveStudents.value = parsedData;
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error fetching active data: $error');
    }
  }

  Future<void> fetchNumberInactiveData() async {
    try {
      var response = await http.get(
        Uri.parse('https://backend-shool-project.onrender.com/chart/students/number_inactive'),
      );

      if (response.statusCode == 201) {
        final data = response.body;
        final decodedData = json.decode(data);
        final parsedData = decodedData['data'] as int?;

        if (parsedData != null) {
          numberOfInactiveStudents.value = parsedData;
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error fetching inactive data: $error');
    }
  }

  Future<void> fetchNumberSuspendedData() async {
    try {
      var response = await http.get(
        Uri.parse('https://backend-shool-project.onrender.com/chart/students/number_suspended'),
      );

      if (response.statusCode == 201) {
        final data = response.body;
        final decodedData = json.decode(data);
        final parsedData = decodedData['data'] as int?;

        if (parsedData != null) {
          numberOfSuspendedStudents.value = parsedData;
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error fetching suspended data: $error');
    }
  }

  Future<void> fetchNumberExpelledData() async {
    try {
      var response = await http.get(
        Uri.parse('https://backend-shool-project.onrender.com/chart/students/number_expelled'),
      );

      if (response.statusCode == 201) {
        final data = response.body;
        final decodedData = json.decode(data);
        final parsedData = decodedData['data'] as int?;

        if (parsedData != null) {
          numberOfExpelledStudents.value = parsedData;
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error fetching expelled data: $error');
    }
  }
}
