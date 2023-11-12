// ignore_for_file: unnecessary_type_check

import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/models/classes.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';

class AddTeacherClassesView extends StatefulWidget {
  const AddTeacherClassesView({super.key});

  @override
  State<AddTeacherClassesView> createState() => _AddTeacherClassesViewState();
}

class _AddTeacherClassesViewState extends State<AddTeacherClassesView> {
  final textClassController = TextEditingController();
  final textTeacherController = TextEditingController();
  String? selectedClassValue;
  String? selectedTeacherValue;
  final isLoading = false.obs;

  Future<List<Classes>> _getClassInfo() async {
    var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/classes'));

    if (response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body)['classes'];

      List<Classes> classes = data.map((e) => Classes.fromJson(e)).toList();

      return classes;
    } else {
      throw Exception('Failed to load classes info');
    }
  }

  Future<List<TeacherData>> _getWorkingTeachers() async {
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

  Future<void> addTeacherToClass() async {
    isLoading(true);
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://backend-shool-project.onrender.com/admin/add-teacher-to-class'),
      );
      request.body = json.encode({"className": selectedClassValue, "teacherId": selectedTeacherValue});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final res = await json.decode(await response.stream.bytesToString());

      print(res);

      if (res['status'] == 'check_class') {
        Get.snackbar(
          "Lỗi",
          "Lớp học không tồn tại.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (res['status'] == 'check_teacher') {
        Get.snackbar(
          "Lỗi",
          "Giáo viên không tồn tại.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (res['status'] == 'check_class_teacher') {
        Get.snackbar(
          "Lỗi",
          "Lớp học đã có giáo viên.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (res['status'] == 'SUCCESS') {
        setState(() {});
        Get.snackbar(
          "Thành công",
          "Giáo viên đã được thêm vào lớp học!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("Add teacher to class: $e");
    }
    isLoading(false);
  }

  @override
  void dispose() {
    super.dispose();
    textClassController.dispose();
    textTeacherController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Thêm giáo viên vào lớp học",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 40),
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: Responsive.isMobile(context) ? null : MediaQuery.of(context).size.width / 3,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Danh sách giáo viên',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<TeacherData>>(
                  future: _getWorkingTeachers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Không có giáo viên nào.'));
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Danh sách giáo viên',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: snapshot.data!
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.sId,
                                        child: Text(
                                          item.fullName.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: selectedTeacherValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedTeacherValue = value;
                                });
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 50,
                                width: double.maxFinite,
                              ),
                              dropdownStyleData: const DropdownStyleData(
                                maxHeight: 500,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 60,
                              ),
                              onMenuStateChange: (isOpen) {
                                if (!isOpen) {
                                  textTeacherController.clear();
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 32),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Danh sách lớp học',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<Classes>>(
                  future: _getClassInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Không có lớp học nào.'));
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Center(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Danh sách lớp học',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: snapshot.data!
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item.className,
                                        child: Text(
                                          item.className.toString(),
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: selectedClassValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedClassValue = value;
                                });
                              },
                              buttonStyleData: const ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 50,
                                width: double.maxFinite,
                              ),
                              dropdownStyleData: const DropdownStyleData(
                                maxHeight: 500,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 60,
                              ),
                              onMenuStateChange: (isOpen) {
                                if (!isOpen) {
                                  textClassController.clear();
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 32),
                Obx(
                  () => InkWell(
                    onTap: () {
                      addTeacherToClass();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.pink,
                      ),
                      child: isLoading.value
                          ? const Center(
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(color: Colors.white),
                              ),
                            )
                          : const Text(
                              'Thêm giáo viên vào lớp học',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
