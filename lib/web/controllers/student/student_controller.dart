// ignore_for_file: unnecessary_type_check

import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/controllers/home/home_controller.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/utils/status/status.dart';

class StudentController extends GetxController {
  final HomeController homeController = Get.put(HomeController());
  final AuthController authController = Get.put(AuthController());

  var allStudents = <Students>[].obs;
  var activeStudents = <Students>[].obs;
  var filteredActiveList = <Students>[].obs;
  var inactiveStudents = <Students>[].obs;
  var suspendedStudents = <Students>[].obs;
  var expelledStudents = <Students>[].obs;

  List<Students> filteredAllStudents = <Students>[].obs;
  List<Students> filteredActiveStudents = <Students>[].obs;
  List<Students> filteredInactiveStudents = <Students>[].obs;
  List<Students> filteredSuspendedStudents = <Students>[].obs;
  List<Students> filteredExpelledStudents = <Students>[].obs;

  final isLoading = false.obs;
  final isEditLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllStudent();
    fetchActiveStudents();
    fetchInactiveStudent();
    fetchSuspendedStudent();
    fetchExpelledStudent();
  }

  // Danh sách tất cả học sinh
  Future<void> fetchAllStudent() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/data/all-students'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];

        if (data is List) {
          List<Students> student = data.map((studentData) => Students.fromJson(studentData)).toList();
          student.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

          allStudents.assignAll(student.reversed);

          filteredAllStudents.assignAll(student.reversed);
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load working student');
      }
    } catch (error) {
      print('Error fetching all students: $error');
    }
  }

  // Danh sách học sinh đang học
  Future<void> fetchActiveStudents() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/data/active-students'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];

        if (data is List) {
          List<Students> student = data.map((studentData) => Students.fromJson(studentData)).toList();
          student.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

          activeStudents.assignAll(student.reversed);
          filteredActiveList.assignAll(activeStudents);
          filteredActiveStudents.assignAll(activeStudents);
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load working student');
      }
    } catch (error) {
      print('Error fetching active students: $error');
    }
  }

  // Danh sách học sinh đã nghỉ học
  Future<void> fetchInactiveStudent() async {
    try {
      var response = await http.get(
        Uri.parse('https://backend-shool-project.onrender.com/data/self-suspended-students'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];

        if (data is List) {
          List<Students> student = data.map((studentData) => Students.fromJson(studentData)).toList();
          student.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

          inactiveStudents.assignAll(student.reversed);
          filteredInactiveStudents.assignAll(student.reversed);
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load working student');
      }
    } catch (error) {
      print('Error fetching inactive students: $error');
    }
  }

  // Danh sách học sinh đang bị đình chỉ
  Future<void> fetchSuspendedStudent() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/data/suspended-students'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];

        if (data is List) {
          List<Students> student = data.map((studentData) => Students.fromJson(studentData)).toList();
          student.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

          suspendedStudents.assignAll(student.reversed);
          filteredSuspendedStudents.assignAll(student.reversed);
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load working student');
      }
    } catch (error) {
      print('Error fetching suspended students: $error');
    }
  }

  // Danh sách học sinh bị đuổi học
  Future<void> fetchExpelledStudent() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/data/expelled-students'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];

        if (data is List) {
          List<Students> student = data.map((studentData) => Students.fromJson(studentData)).toList();
          student.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

          expelledStudents.assignAll(student.reversed);
          filteredExpelledStudents.assignAll(student.reversed);
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load working student');
      }
    } catch (error) {
      print('Error fetching expelled students: $error');
    }
  }

  void searchStudent(String query) {
    if (query.isEmpty) {
      filteredActiveList.assignAll(activeStudents);
    } else {
      final lowerCaseQuery = query.toLowerCase();

      filteredActiveList.assignAll(
        activeStudents
            .where(
              (fee) =>
                  fee.mssv!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.fullName!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.phone!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.gmail!.toLowerCase().contains(lowerCaseQuery),
            )
            .toList(),
      );
    }
  }

  void searchAllStudent(String query) {
    if (query.isEmpty) {
      filteredAllStudents.assignAll(allStudents);
      filteredActiveStudents.assignAll(activeStudents);
      filteredInactiveStudents.assignAll(inactiveStudents);
      filteredSuspendedStudents.assignAll(suspendedStudents);
      filteredExpelledStudents.assignAll(expelledStudents);
    } else {
      final lowerCaseQuery = query.toLowerCase();

      filteredAllStudents.assignAll(
        allStudents
            .where(
              (fee) =>
                  fee.mssv!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.fullName!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.phone!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.gmail!.toLowerCase().contains(lowerCaseQuery),
            )
            .toList(),
      );
      filteredActiveStudents.assignAll(
        activeStudents
            .where(
              (fee) =>
                  fee.mssv!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.fullName!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.phone!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.gmail!.toLowerCase().contains(lowerCaseQuery),
            )
            .toList(),
      );
      filteredInactiveStudents.assignAll(
        inactiveStudents
            .where(
              (fee) =>
                  fee.mssv!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.fullName!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.phone!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.gmail!.toLowerCase().contains(lowerCaseQuery),
            )
            .toList(),
      );
      filteredSuspendedStudents.assignAll(
        suspendedStudents
            .where(
              (fee) =>
                  fee.mssv!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.fullName!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.phone!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.gmail!.toLowerCase().contains(lowerCaseQuery),
            )
            .toList(),
      );
      filteredExpelledStudents.assignAll(
        expelledStudents
            .where(
              (fee) =>
                  fee.mssv!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.fullName!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.phone!.toLowerCase().contains(lowerCaseQuery) ||
                  fee.gmail!.toLowerCase().contains(lowerCaseQuery),
            )
            .toList(),
      );
    }
  }

  Future<dynamic> addStudent({
    required String fullName,
    required String gmail,
    required String phone,
    required String cccd,
    required String major,
    required String birthDate,
    required String gender,
    required String customYear,
    required String contactPhone,
    required String contactAddress,
    required String ethnicity,
    required String beneficiary,
    required String fatherFullName,
    required String motherFullName,
    required String notes,
    required String address,
    required String city,
    required String district,
    required String ward,
  }) async {
    try {
      isLoading(true);

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('https://backend-shool-project.onrender.com/admin/signup'));
      request.body = json.encode({
        "fullName": fullName.trim(),
        "gmail": gmail.trim(),
        "phone": phone.trim(),
        "cccd": cccd.trim(),
        "major": major.trim(),
        "birthDate": birthDate,
        "customYear": customYear.trim(),
        "gender": gender.trim(),
        "contactPhone": contactPhone.trim(),
        "contactAddress": contactAddress.trim(),
        "ethnicity": ethnicity.trim(),
        "beneficiary": beneficiary.trim(),
        "fatherFullName": fatherFullName.trim(),
        "motherFullName": motherFullName.trim(),
        "notes": notes.trim(),
        "address": address.trim(),
        "city": city.trim(),
        "district": district.trim(),
        "ward": ward.trim(),
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final res = await json.decode(await response.stream.bytesToString());

      if (res['status'] == 'check_email') {
        showErrorStatus('Email đã tồn tại');

        isLoading(false);
      } else if (res['status'] == 'check_phone') {
        showErrorStatus('Số điện thoại đã tồn tại');

        isLoading(false);
      } else if (res['status'] == 'check_cccd') {
        showErrorStatus('CCCD đã tồn tại');

        isLoading(false);
      } else if (res['status'] == 'invalid_major') {
        showErrorStatus('Chuyên ngành được cung cấp không hợp lệ');

        isLoading(false);
      } else if (res['status'] == 'SUCCESS') {
        showSuccessStatus('Học sinh đã được thêm thành công, kiểm tra email của bạn để biết thông tin tài khoản');

        fetchAllStudent();
        fetchActiveStudents();
        homeController.fetchAllStudentData();
        homeController.fetchActiveStudents();
        homeController.totalNewStudentData();
        authController.loadData();

        Get.back();
        isLoading(false);
      } else {
        showErrorStatus('Lỗi kết nối!');

        isLoading(false);
      }
    } catch (error) {
      print('Lỗi add student: $error');
    } finally {
      isLoading(false);
    }
  }

  Future<dynamic> editStudent(
    String uid, {
    required String fullName,
    required String gmail,
    required String phone,
    required String cccd,
    required String major,
    required String birthDate,
    required String gender,
    required String customYear,
    required String contactPhone,
    required String contactAddress,
    required String ethnicity,
    required String beneficiary,
    required String fatherFullName,
    required String motherFullName,
    required String notes,
    required String address,
    required String city,
    required String district,
    required String ward,
  }) async {
    try {
      isEditLoading(true);

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'PUT',
        Uri.parse('https://backend-shool-project.onrender.com/user/update/student/$uid'),
      );
      request.body = json.encode({
        "fullName": fullName.trim(),
        "gmail": gmail.trim(),
        "phone": phone.trim(),
        "cccd": cccd.trim(),
        "major": major.trim(),
        "birthDate": birthDate,
        "customYear": customYear.trim(),
        "gender": gender.trim(),
        "contactPhone": contactPhone.trim(),
        "contactAddress": contactAddress.trim(),
        "ethnicity": ethnicity.trim(),
        "beneficiary": beneficiary.trim(),
        "fatherFullName": fatherFullName.trim(),
        "motherFullName": motherFullName.trim(),
        "notes": notes.trim(),
        "address": address.trim(),
        "city": city.trim(),
        "district": district.trim(),
        "ward": ward.trim(),
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final res = await json.decode(await response.stream.bytesToString());

      if (res['status'] == 'check_gmail') {
        showErrorStatus('Email đã tồn tại');

        isEditLoading(false);
      } else if (res['status'] == 'check_phone') {
        showErrorStatus('Số điện thoại đã tồn tại');

        isEditLoading(false);
      } else if (res['status'] == 'check_cccd') {
        showErrorStatus('CCCD đã tồn tại');

        isEditLoading(false);
      } else if (res['status'] == 'invalid_major') {
        showErrorStatus('Chuyên ngành được cung cấp không hợp lệ');

        isEditLoading(false);
      } else if (res['status'] == 'SUCCESS') {
        showSuccessStatus('Chỉnh sửa thông tin thành công');

        fetchAllStudent();
        fetchActiveStudents();
        homeController.fetchAllStudentData();
        homeController.fetchActiveStudents();
        homeController.totalNewStudentData();
        authController.loadData();

        Get.back();
        isEditLoading(false);
      } else {
        showErrorStatus('Lỗi kết nối. Vui lòng thử lại sau!');

        isEditLoading(false);
      }
    } catch (error) {
      print('Lỗi add student: $error');
    } finally {
      isEditLoading(false);
    }
  }
}
