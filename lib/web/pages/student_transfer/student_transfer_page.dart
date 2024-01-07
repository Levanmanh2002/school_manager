import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/controllers/teacher/teacher_controller.dart';
import 'package:school_web/web/models/classes.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/screen/student/detail/student_detail_screen.dart';
import 'package:school_web/web/widgets/full_screen_image_screen.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class StudentTransferPage extends StatefulWidget {
  const StudentTransferPage({super.key});

  @override
  State<StudentTransferPage> createState() => _StudentTransferPageState();
}

class _StudentTransferPageState extends State<StudentTransferPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final textClassController = TextEditingController();
  final authController = Get.put(AuthenticationController());
  final searchController = TextEditingController();
  final isLoading = false.obs;
  final isLoadingBtn = false.obs;
  String errorMessage = '';
  StudentData? student;
  bool _isClearIconVisible = false;
  String? selectedClassValue;

  Future<void> fetchData(String query) async {
    isLoading(true);

    try {
      final response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/user/check/$query'));

      if (response.statusCode == 404) {
        setState(() {
          errorMessage = 'Không tìm thấy học sinh';
          student = null;
        });
      } else if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        final studentData = jsonData['student'];

        setState(() {
          student = StudentData.fromJson(studentData);
          errorMessage = '';
        });
      } else {
        print('Failed to fetch data: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi: $e';
        student = null;
      });
    }

    isLoading(false);
  }

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

  Future<void> moveStudentToNewClass() async {
    isLoadingBtn(true);
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://backend-shool-project.onrender.com/admin/move-student-to-new-class'),
      );
      request.body = json.encode({"studentMSSV": searchController.text, "newClassName": selectedClassValue});
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
      } else if (res['status'] == 'check_class_student') {
        Get.snackbar(
          "Lỗi",
          "Lớp học hiện tại không tồn tại.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (res['status'] == 'check_class') {
        Get.snackbar(
          "Lỗi",
          "Lớp học mới không tồn tại.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (res['status'] == 'SUCCESS') {
        Get.back();
        Get.snackbar(
          "Thành công",
          "Chuyển học sinh thành công!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Move student to new class $e');
    }

    isLoadingBtn(false);
  }

  @override
  void initState() {
    super.initState();
    authController.getProfileData();
    searchController.addListener(_onTextChanged);
    textClassController.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isClearIconVisible = searchController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
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
            'Học sinh chuyển lớp',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Container(
              width: Responsive.isMobile(context) ? null : MediaQuery.of(context).size.width / 3,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'Vui lòng nhập MSSV',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF373A43)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      controller: searchController,
                      onChanged: fetchData,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[.,-/]')),
                        LengthLimitingTextInputFormatter(25),
                      ],
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm",
                        suffixIcon: _isClearIconVisible
                            ? IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  student = null;
                                },
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Thông tin không được để trống';
                        }

                        return null;
                      },
                    ),
                  ),
                  if (_isClearIconVisible)
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: (student != null) ? Colors.grey[200] : Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          if (errorMessage.isNotEmpty)
                            Text(
                              errorMessage,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (student != null)
                            Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    elevation: 1,
                                    color: Colors.white,
                                    child: ListTile(
                                      leading: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FullScreenImageScreen(
                                                imageUrl: student?.avatarUrl ??
                                                    'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                                              ),
                                            ),
                                          );
                                        },
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            student?.avatarUrl ??
                                                'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                                          ),
                                          radius: 30,
                                        ),
                                      ),
                                      title: Text(
                                        student?.fullName ?? '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(student?.mssv ?? ''),
                                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StudentDetailScreen(student: student!),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 32),
                  if (student != null)
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Lớp học mà học sinh muốn chuyển đến',
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
                      ],
                    ),
                  const SizedBox(height: 32),
                  Obx(
                    () => InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          if (student != null) {
                            if (authController.teacherData.value?.system == 1 ||
                                authController.teacherData.value?.system == 2 ||
                                authController.teacherData.value?.system == 3) {
                              moveStudentToNewClass();
                            } else {
                              showNoSystemWidget(
                                context,
                                title: 'Bạn không có quyền giáo viên',
                                des: 'Xin lỗi, bạn không có quyền truy cập chức năng của giáo viên.',
                                cancel: 'Hủy',
                                confirm: 'Xác nhận',
                                ontap: () => Navigator.pop(context),
                              );
                            }
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.primaryColor,
                        ),
                        child: isLoadingBtn.value
                            ? const Center(
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(color: Colors.white),
                                ),
                              )
                            : const Text(
                                'Xác nhận',
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
      ),
    );
  }
}
