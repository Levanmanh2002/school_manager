// ignore_for_file: unnecessary_type_check, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/screen/classes/detail/class_info_detail.dart';
import 'package:school_web/web/pages/screen/classes/view/controller/class_controller.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class ClassesInfoView extends StatefulWidget {
  const ClassesInfoView({super.key});

  @override
  State<ClassesInfoView> createState() => _ClassesInfoViewState();
}

class _ClassesInfoViewState extends State<ClassesInfoView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ClassesController controller = Get.put(ClassesController());
  final _createClassController = TextEditingController();
  final _updatedClassController = TextEditingController();

  Future<void> _addClass() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('https://backend-shool-project.onrender.com/admin/create-class'));
      request.body = json.encode({"className": _createClassController.text});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        Get.snackbar(
          "Thành công",
          "Lớp học mới đã được tạo",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        _createClassController.clear();
        await controller.getClassInfo();
      } else if (response.statusCode == 400) {
        Get.snackbar(
          "Thất bại",
          "Lớp học đã tồn tại!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Create class + $e');
    }
  }

  Future<void> _editClass(String id) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'PUT',
        Uri.parse('https://backend-shool-project.onrender.com/admin/edit-class/$id'),
      );
      request.body = json.encode({
        "updatedClassName": _updatedClassController.text,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        Get.snackbar(
          "Thành công",
          "Lớp học đã được chỉnh sửa",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        _updatedClassController.clear();
        await controller.getClassInfo();
      } else if (response.statusCode == 404) {
        Get.snackbar(
          "Thất bại",
          "Lớp học không tồn tại!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Edit class + $e');
    }
  }

  Future<void> _deleteClass(String id) async {
    try {
      var request = http.Request(
        'DELETE',
        Uri.parse('https://backend-shool-project.onrender.com/admin/delete-class/$id'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        Get.snackbar(
          "Thành công",
          "Lớp học đã được xóa",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await controller.getClassInfo();
      } else if (response.statusCode == 404) {
        Get.snackbar(
          "Thất bại",
          "Lớp học không tồn tại!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Delete class + $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _createClassController.dispose();
    _updatedClassController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: Responsive.isMobile(context) ? 16 : 32),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Danh sách lớp học',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.blackColor),
                  ),
                  InkWell(
                    onTap: () {
                      addClasses(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primaryColor,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(IconAssets.booksIcon),
                          const SizedBox(width: 8),
                          const Text(
                            'Tạo lớp học',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.whiteColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(Responsive.isMobile(context) ? 12 : 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x143A73C2),
                      blurRadius: 8.0,
                      offset: Offset(0, 0),
                    ),
                    BoxShadow(
                      color: Color(0x143A73C2),
                      blurRadius: 8.0,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Danh sách lớp học',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.blackColor),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColors.primary50Color,
                      ),
                      child: Obx(
                        () => Text(
                          'Tổng số lớp học: ${controller.classesList.length}',
                          style:
                              const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          itemText(context),
                          const SizedBox(height: 12),
                          Obx(
                            () {
                              if (controller.classesList != null) {
                                if (controller.classesList.isNotEmpty) {
                                  return Column(
                                    children: controller.classesList.map((classInfo) {
                                      return itemDataText(
                                        nameClass: classInfo.className ?? '',
                                        teacher: classInfo.teacher != null && classInfo.teacher!.isNotEmpty
                                            ? classInfo.teacher!.first.fullName ?? ''
                                            : '',
                                        listStudent: classInfo.className ?? '',
                                        viewClassOnTap: () {
                                          if (classInfo.students != null) {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => ClassesInfoDetail(
                                                  students: classInfo.students,
                                                  classes: classInfo.className.toString(),
                                                ),
                                              ),
                                            );
                                          } else {
                                            Get.snackbar(
                                              "Lỗi",
                                              "Lớp học chưa có học sinh.",
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                            );
                                          }
                                        },
                                        deleteOnTap: () {
                                          showNoSystemWidget(
                                            context,
                                            title: 'Xác nhận xóa lớp?',
                                            des: 'Bạn có chắc chắn muốn xóa, không thể khôi phục khi đã xóa?',
                                            cancel: 'Hủy',
                                            confirm: 'Xác nhận',
                                            ontap: () {
                                              Navigator.of(context).pop();
                                              _deleteClass(classInfo.id.toString());
                                            },
                                          );
                                        },
                                        editOnTap: () => editClasses(
                                          context,
                                          classInfo.className.toString(),
                                          () => _editClass(classInfo.id.toString()),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              } else {
                                return const Text('Data is null');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemDataText({
    required String nameClass,
    required String teacher,
    required String listStudent,
    required VoidCallback deleteOnTap,
    required VoidCallback editOnTap,
    required VoidCallback viewClassOnTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: Responsive.isMobile(context)
                ? MediaQuery.of(context).size.width / 3
                : MediaQuery.of(context).size.width / 6,
            child: Text(
              nameClass,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDesColor),
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: Responsive.isMobile(context)
                ? MediaQuery.of(context).size.width / 3
                : MediaQuery.of(context).size.width / 6,
            child: Text(
              teacher,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDesColor),
            ),
          ),
          // SizedBox(
          //   width: Responsive.isMobile(context)
          //       ? MediaQuery.of(context).size.width / 3
          //       : MediaQuery.of(context).size.width / 6.6,
          //   child: const Text(
          //     'Khoa',
          //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDesColor),
          //   ),
          // ),
          const SizedBox(width: 24),
          SizedBox(
            width: Responsive.isMobile(context)
                ? MediaQuery.of(context).size.width / 3
                : MediaQuery.of(context).size.width / 7.8,
            child: InkWell(
              onTap: viewClassOnTap,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primary300,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Danh sách lớp $listStudent',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.whiteColor,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(IconAssets.shareIcon),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          SizedBox(
            width: Responsive.isMobile(context)
                ? MediaQuery.of(context).size.width / 3
                : MediaQuery.of(context).size.width / 6.2,
            child: Row(
              children: [
                InkWell(
                  onTap: deleteOnTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.redColor,
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Xóa',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.clear, size: 12, color: AppColors.whiteColor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: editOnTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primaryColor,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Sửa',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.whiteColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset(IconAssets.editIcon),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void addClasses(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            alignment: Alignment.center,
            child: const Text(
              'Thêm một lớp học mới',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextWidgets(
                  controller: _createClassController,
                  title: 'Tên lớp học',
                  validator: true,
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
                        if (_formKey.currentState!.validate()) {
                          _addClass();
                          Navigator.of(context).pop();
                        }
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void editClasses(BuildContext context, String className, VoidCallback editOnTap) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: const Text(
              'Chỉnh sửa thông tin lớp học',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextWidgets(
                  controller: _updatedClassController,
                  title: 'Tên lớp học',
                  hintText: className,
                  validator: true,
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
                        if (_formKey.currentState!.validate()) {
                          editOnTap();
                          Navigator.of(context).pop();
                        }
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Row itemText(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width / 3
              : MediaQuery.of(context).size.width / 6,
          child: const Text(
            'Tên lớp',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDesColor),
          ),
        ),
        const SizedBox(width: 24),
        SizedBox(
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width / 3
              : MediaQuery.of(context).size.width / 6,
          child: const Text(
            'Giáo viên chủ nhiệm',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDesColor),
          ),
        ),
        const SizedBox(width: 24),
        // SizedBox(
        //   width: Responsive.isMobile(context)
        //       ? MediaQuery.of(context).size.width / 3
        //       : MediaQuery.of(context).size.width / 6.6,
        //   child: const Text(
        //     'Khoa',
        //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDesColor),
        //   ),
        // ),
        SizedBox(
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width / 3
              : MediaQuery.of(context).size.width / 7.8,
          child: const Text(
            'Danh sách học sinh',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDesColor),
          ),
        ),
        const SizedBox(width: 24),
        SizedBox(
          width: Responsive.isMobile(context)
              ? MediaQuery.of(context).size.width / 3
              : MediaQuery.of(context).size.width / 6,
          child: const Text(
            'Hành động',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textDesColor),
          ),
        ),
      ],
    );
  }
}
