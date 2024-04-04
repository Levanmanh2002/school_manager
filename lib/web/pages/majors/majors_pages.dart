import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/controllers/auth_controller.dart';
import 'package:school_web/web/controllers/majors/majors_controller.dart';
import 'package:school_web/web/models/majors_models.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/majors/widget/card_widget.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class MajorsPages extends StatefulWidget {
  const MajorsPages({super.key});

  @override
  State<MajorsPages> createState() => _MajorsPagesState();
}

class _MajorsPagesState extends State<MajorsPages> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MajorsController majorsController = Get.put(MajorsController());
  final AuthController authController = Get.put(AuthController());

  final nameController = TextEditingController();
  final desController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    desController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? 16 : 32, vertical: 24),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Ngành nghề',
                    style: TextStyle(
                      fontSize: Responsive.isMobile(context) ? 18 : 24,
                      fontWeight: FontWeight.w600,
                      color: appTheme.blackColor,
                    ),
                  ),
                  const Spacer(),
                  Opacity(
                    opacity: authController.teacherData.value?.system == 1 ||
                            authController.teacherData.value?.system == 2 ||
                            authController.teacherData.value?.system == 3
                        ? 1
                        : 0.5,
                    child: InkWell(
                      onTap: () {
                        if (authController.teacherData.value?.system == 1 ||
                            authController.teacherData.value?.system == 2) {
                          _showAddMajorsConfirmationDialog(context);
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
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: Responsive.isMobile(context) ? 4 : 8, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: appTheme.appColor,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(IconAssets.booksIcon),
                            const SizedBox(width: 8),
                            Text(
                              'Tạo ngành nghề',
                              style: StyleThemeData.styleSize14Weight500(color: appTheme.whiteColor, height: 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Obx(
                () => Wrap(
                  spacing: 12,
                  runSpacing: Responsive.isMobile(context) ? 12 : 32,
                  children: List.generate(
                    majorsController.majorsList.length,
                    (index) {
                      final majors = majorsController.majorsList[index];

                      return CardWidget(
                        onTap: () {
                          if (authController.teacherData.value?.system == 1 ||
                              authController.teacherData.value?.system == 2 ||
                              authController.teacherData.value?.system == 3) {
                            final nameEditController = TextEditingController(text: majors.name);
                            final desEditController = TextEditingController(text: majors.description);

                            _showEditMajorsConfirmationDialog(
                              context,
                              majors,
                              nameEditController,
                              desEditController,
                            );
                          }
                        },
                        text: majors.name ?? '',
                        des: majors.description ?? '',
                        showClear: authController.teacherData.value?.system == 1 ||
                            authController.teacherData.value?.system == 2 ||
                            authController.teacherData.value?.system == 3,
                        clearOntap: () {
                          if (authController.teacherData.value?.system == 1 ||
                              authController.teacherData.value?.system == 2) {
                            _showDeleteMajorsConfirmationDialog(context, majors);
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
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showAddMajorsConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            'Tạo ngành nghề mới',
            style: StyleThemeData.styleSize16Weight800(),
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tên ngành nghề',
                      style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Nhập tên ngành',
                      hintStyle: StyleThemeData.styleSize14Weight400(color: const Color(0xFFB6BBC3)),
                      errorStyle: TextStyle(color: appTheme.errorColor),
                      labelStyle: StyleThemeData.styleSize14Weight400(),
                      border: const OutlineInputBorder(),
                      prefix: const SizedBox(width: 12),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: appTheme.errorColor),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: appTheme.errorColor),
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
                        return 'Tên ngành nghề không được để trống';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Mô tả ngành nghề',
                      style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: desController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(300),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Mô tả ngành nghề',
                      hintStyle: StyleThemeData.styleSize14Weight400(color: const Color(0xFFB6BBC3)),
                      errorStyle: TextStyle(color: appTheme.errorColor),
                      labelStyle: StyleThemeData.styleSize14Weight400(),
                      border: const OutlineInputBorder(),
                      prefix: const SizedBox(width: 12),
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: appTheme.errorColor),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: appTheme.errorColor),
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
                            color: appTheme.whiteColor,
                            border: Border.all(color: appTheme.textDesColor),
                          ),
                          child: Text(
                            'Hủy',
                            style: StyleThemeData.styleSize16Weight600(color: appTheme.textDesColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(context).pop();
                            await majorsController.addMajors(
                              nameController: nameController.text,
                              desController: desController.text,
                            );

                            nameController.clear();
                            desController.clear();
                          }
                        },
                        child: Container(
                          width: 99,
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: appTheme.appColor,
                          ),
                          child: Text(
                            'Xác nhận',
                            style: StyleThemeData.styleSize16Weight600(color: appTheme.whiteColor),
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

  _showEditMajorsConfirmationDialog(
    BuildContext context,
    MajorsData majorsData,
    TextEditingController nameEditController,
    TextEditingController desEditController,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            'Chỉnh sửa thông tin ngành nghề',
            style: StyleThemeData.styleSize16Weight800(),
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: _formKey,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 842, minWidth: 385),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Vui lòng nhập thông tin để chỉnh sửa ngành nghề?',
                      style: StyleThemeData.styleSize12Weight400(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tên ngành nghề',
                      style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameEditController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50),
                    ],
                    decoration: InputDecoration(
                      hintText: majorsData.name,
                      hintStyle: StyleThemeData.styleSize14Weight400(color: const Color(0xFFB6BBC3)),
                      errorStyle: TextStyle(color: appTheme.errorColor),
                      labelStyle: StyleThemeData.styleSize14Weight400(),
                      border: const OutlineInputBorder(),
                      prefix: const SizedBox(width: 12),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: appTheme.errorColor),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: appTheme.errorColor),
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
                        return 'Tên ngành nghề không được để trống';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Mô tả ngành nghề',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textDesColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: desEditController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(300),
                    ],
                    decoration: InputDecoration(
                      hintText: majorsData.description,
                      hintStyle: StyleThemeData.styleSize14Weight400(color: const Color(0xFFB6BBC3)),
                      errorStyle: TextStyle(color: appTheme.errorColor),
                      labelStyle: StyleThemeData.styleSize14Weight400(),
                      border: const OutlineInputBorder(),
                      prefix: const SizedBox(width: 12),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: appTheme.errorColor),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: appTheme.errorColor),
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
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: appTheme.whiteColor,
                            border: Border.all(color: appTheme.textDesColor),
                          ),
                          child: Text(
                            'Hủy',
                            style: StyleThemeData.styleSize16Weight600(color: appTheme.textDesColor),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(context).pop();
                            await majorsController.onEditMajors(
                              majorsData.sId.toString(),
                              nameEditController: nameEditController.text,
                              desEditController: desEditController.text,
                            );

                            nameEditController.clear();
                            desEditController.clear();
                          }
                        },
                        child: Container(
                          width: 99,
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: appTheme.appColor,
                          ),
                          child: Text(
                            'Xác nhận',
                            style: StyleThemeData.styleSize16Weight600(color: appTheme.whiteColor),
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

  Future<bool?> _showDeleteMajorsConfirmationDialog(BuildContext context, MajorsData majorsData) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            "Xác nhận xóa ngành nghề",
            style: StyleThemeData.styleSize16Weight600(),
          ),
          content: Text(
            "Bạn có chắc chắn muốn xóa ngành nghề ${majorsData.name}?",
            style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
          ),
          actions: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: appTheme.textDesColor),
                ),
                child: Text(
                  'Hủy',
                  style: StyleThemeData.styleSize14Weight700(color: appTheme.textDesColor),
                ),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () async {
                Navigator.of(context).pop();
                await majorsController.onDeleteMajors(majorsData.sId.toString());
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: appTheme.appColor,
                ),
                child: Text(
                  'Xác nhận',
                  style: StyleThemeData.styleSize14Weight700(color: appTheme.whiteColor),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
