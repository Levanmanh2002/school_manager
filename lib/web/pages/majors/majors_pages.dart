import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/models/majors_models.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/majors/widget/card_widget.dart';
import 'package:school_web/web/utils/assets/icons.dart';

class MajorsPages extends StatefulWidget {
  const MajorsPages({super.key});

  @override
  State<MajorsPages> createState() => _MajorsPagesState();
}

class _MajorsPagesState extends State<MajorsPages> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController editNameController = TextEditingController();
  final TextEditingController editDescriptionController = TextEditingController();

  Future<List<MajorsData>> fetchMajors() async {
    final response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/majors'));

    if (response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body)['data'];

      List<MajorsData> majors = data.map((e) => MajorsData.fromJson(e)).toList();

      return majors;
    } else {
      print(response.reasonPhrase);
    }
    return [];
  }

  Future<dynamic> addMajors() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('https://backend-shool-project.onrender.com/admin/add-major'));
    request.body = json.encode({"name": nameController.text, "description": descriptionController.text});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      setState(() {});
      Get.snackbar(
        "Thành công",
        "Ngành học mới đã được thêm thành công!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      print(await response.stream.bytesToString());
    } else {
      Get.snackbar(
        "Thất bại",
        "Thêm mới ngành học thất bại!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(response.reasonPhrase);
    }
  }

  Future<void> onEditMajors(String id) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('PUT', Uri.parse('https://backend-shool-project.onrender.com/admin/edit-major/$id'));
    request.body = json.encode({"name": editNameController.text, "description": editDescriptionController.text});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      setState(() {});
      Get.snackbar(
        "Thành công",
        "Ngành học đã được chỉnh sửa!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      editNameController.clear();
      editDescriptionController.clear();
      print(await response.stream.bytesToString());
    } else if (response.statusCode == 400) {
      Get.snackbar(
        "Thất bại",
        "Ngành học đã tồn tại!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Thất bại",
        "Chỉnh sửa ngành học thất bại!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(response.reasonPhrase);
    }
  }

  Future<dynamic> onDeleteMajors(String id) async {
    var request =
        http.Request('DELETE', Uri.parse('https://backend-shool-project.onrender.com/admin/delete-major/$id'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      setState(() {});
      Get.snackbar(
        "Thành công",
        "Ngành học đã được xóa!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      print(await response.stream.bytesToString());
    } else {
      Get.snackbar(
        "Thất bại",
        "Lỗi xóa ngành học!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print(response.reasonPhrase);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    editNameController.dispose();
    editDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Ngành học',
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context) ? 18 : 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    _showAddMajorsConfirmationDialog(context, addMajors);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: Responsive.isMobile(context) ? 4 : 8, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primaryColor,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(IconAssets.booksIcon),
                        const SizedBox(width: 8),
                        const Text(
                          'Tạo ngành học',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FutureBuilder<List<MajorsData>>(
              future: fetchMajors(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return Wrap(
                    spacing: 12,
                    runSpacing: Responsive.isMobile(context) ? 12 : 32,
                    children: List.generate(
                      snapshot.data!.length,
                      (index) {
                        final majors = snapshot.data![index];

                        return CardWidget(
                          onTap: () {
                            _showEditMajorsConfirmationDialog(context, majors, onEditMajors);
                          },
                          text: majors.name ?? '',
                          des: majors.description ?? '',
                          clearOntap: () {
                            _showDeleteMajorsConfirmationDialog(context, majors, onDeleteMajors);
                          },
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _showAddMajorsConfirmationDialog(BuildContext context, dynamic addMajors) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            'Tạo ngành học mới',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: _formKey,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 842, minWidth: 385),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tên ngành học',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textDesColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Nhập tên ngành',
                      hintStyle: TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
                      errorStyle: TextStyle(color: Colors.red),
                      labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(),
                      prefix: SizedBox(width: 12),
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tên ngành học không được để trống';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Mô tả ngành học',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textDesColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descriptionController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(300),
                    ],
                    decoration: const InputDecoration(
                      hintText: 'Mô tả ngành học',
                      hintStyle: TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
                      errorStyle: TextStyle(color: Colors.red),
                      labelStyle: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(),
                      prefix: SizedBox(width: 12),
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mô tả không được để trống';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: AppColors.textDesColor),
                          ),
                          child: const Text(
                            'Hủy',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDesColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            addMajors();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          width: 99,
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.primaryColor,
                          ),
                          child: const Text(
                            'Xác nhận',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.whiteColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _showEditMajorsConfirmationDialog(BuildContext context, MajorsData majorsData, dynamic addMajors) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text(
            'Chỉnh sửa thông tin ngành học',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: _formKey,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 842, minWidth: 385),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Vui lòng nhập thông tin để chỉnh sửa ngành học?',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tên ngành học',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textDesColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: editNameController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    decoration: InputDecoration(
                      hintText: majorsData.name,
                      hintStyle: const TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
                      errorStyle: const TextStyle(color: Colors.red),
                      labelStyle: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                      border: const OutlineInputBorder(),
                      prefix: const SizedBox(width: 12),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
                        return 'Tên ngành học không được để trống';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Mô tả ngành học',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textDesColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: editDescriptionController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(300),
                    ],
                    decoration: InputDecoration(
                      hintText: majorsData.description,
                      hintStyle: const TextStyle(color: Color(0xFFB6BBC3), fontSize: 14, fontWeight: FontWeight.w400),
                      errorStyle: const TextStyle(color: Colors.red),
                      labelStyle: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                      border: const OutlineInputBorder(),
                      prefix: const SizedBox(width: 12),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
                        return 'Mô tả không được để trống';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            border: Border.all(color: AppColors.textDesColor),
                          ),
                          child: const Text(
                            'Hủy',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDesColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            addMajors(majorsData.sId);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          width: 99,
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.primaryColor,
                          ),
                          child: const Text(
                            'Xác nhận',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.whiteColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteMajorsConfirmationDialog(
      BuildContext context, MajorsData majorsData, dynamic onDeleteMajors) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text(
            "Xác nhận xóa ngành học",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.blackColor,
            ),
          ),
          content: Text(
            "Bạn có chắc chắn muốn xóa ngành học ${majorsData.name}?",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDesColor),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.textDesColor),
                ),
                child: const Text(
                  'Hủy',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textDesColor),
                ),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                onDeleteMajors(majorsData.sId);
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primaryColor,
                ),
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.whiteColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
