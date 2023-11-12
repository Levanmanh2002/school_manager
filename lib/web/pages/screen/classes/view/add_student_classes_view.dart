import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/models/classes.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';

class AddStudentClassesView extends StatefulWidget {
  const AddStudentClassesView({super.key});

  @override
  State<AddStudentClassesView> createState() => _AddStudentClassesViewState();
}

class _AddStudentClassesViewState extends State<AddStudentClassesView> {
  final textClassController = TextEditingController();
  final textStudentClassController = TextEditingController();
  String? selectedClassValue;
  String? selectedStudentClassValue;
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

  Future<List<StudentData>> _getWithoutClassInfo() async {
    var response = await http.get(
      Uri.parse('https://backend-shool-project.onrender.com/admin/students-without-class'),
    );

    if (response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body)['studentsWithoutClass'];

      List<StudentData> student = data.map((e) => StudentData.fromJson(e)).toList();

      return student;
    } else {
      throw Exception('Failed to load classes info');
    }
  }

  Future<void> _addStudentToClass() async {
    isLoading(true);

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://backend-shool-project.onrender.com/admin/add-students-to-class'),
      );
      request.body = json.encode({
        "studentIds": [selectedStudentClassValue],
        "className": selectedClassValue
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final res = await json.decode(await response.stream.bytesToString());

      print(res);

      if (res['status'] == 'check_student') {
        Get.snackbar(
          "Lỗi",
          "Học sinh không tồn tại.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (res['status'] == 'check_student_class') {
        Get.snackbar(
          "Lỗi",
          "Học sinh đã có lớp học.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (res['status'] == 'check_class') {
        Get.snackbar(
          "Lỗi",
          "Lớp học không tồn tại.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (res['status'] == 'check_full_class') {
        Get.snackbar(
          "Lỗi",
          "Lớp học đã đạt đủ 30 học sinh.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (res['status'] == 'SUCCESS') {
        setState(() {});
        Get.snackbar(
          "Thành công",
          "Thêm học sinh vào lớp thành công!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Add student class $e');
    }

    isLoading(false);
  }

  @override
  void dispose() {
    super.dispose();
    textClassController.dispose();
    textStudentClassController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Thêm học sinh mới vào lớp học',
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
                    'Tên lớp học',
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
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Tên học sinh',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<StudentData>>(
                  future: _getWithoutClassInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Không có học sinh nào chưa có lớp học.'));
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
                                'Danh sách học sinh chưa có lớp học',
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
                              value: selectedStudentClassValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedStudentClassValue = value;
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
                                  textStudentClassController.clear();
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
                      _addStudentToClass();
                    },
                    child: isLoading.value
                        ? const Center(
                            child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator()),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.pink,
                            ),
                            child: const Text(
                              'Thêm học sinh vào lớp học',
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
