import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/controllers/system/system_controller.dart';
import 'package:school_web/web/controllers/teacher/teacher_controller.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/screen/teacher/detail/teacher_detail_screen.dart';
import 'package:school_web/web/pages/system/update_view.dart';
import 'package:school_web/web/pages/system/widget/item_info_list_widget.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/utils/formatter/no_initial_spaceInput_formatter_widgets.dart';
import 'package:school_web/web/widgets/box_shadow_widget.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class SystemPages extends StatefulWidget {
  const SystemPages({super.key});

  @override
  State<SystemPages> createState() => _SystemPagesState();
}

class _SystemPagesState extends State<SystemPages> {
  final AuthController authController = Get.put(AuthController());
  final SystemController systemController = Get.put(SystemController());
  final TeacherController teacherController = Get.put(TeacherController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Padding(
          padding: Responsive.isMobile(context)
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 24)
              : const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Danh sách vai trò',
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context) ? 18 : 24,
                    fontWeight: FontWeight.w600,
                    color: appTheme.blackColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BoxShadowWidget(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      child: CustomTextWidgets(
                        boolTitle: true,
                        hintText: 'Tìm kiếm',
                        borderRadius: 41,
                        prefixIcon: IconButton(
                          onPressed: null,
                          icon: SvgPicture.asset(IconAssets.searchIcon, width: 20, height: 20),
                        ),
                        showBorder: BorderSide(color: appTheme.transparentColor),
                        fillColor: appTheme.primary400Color,
                        onChanged: (search) {
                          teacherController.searchTeachers(search);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'\s\s\s+')),
                          LengthLimitingTextInputFormatter(50),
                          NoInitialSpaceInputFormatterWidgets(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: appTheme.primary50Color,
                          ),
                          child: Text(
                            'Số lượng: ${teacherController.workingTeachers.length}',
                            style: StyleThemeData.styleSize14Weight400(color: appTheme.appColor),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Divider(height: 0, thickness: 1),
                    ),
                    itemDataTeacher(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemDataTeacher() {
    bool useRedBorder = false;

    return Obx(() {
      final List<TeacherData> teachers = teacherController.filteredTeachers;

      return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: teachers.map((teacher) {
            useRedBorder = !useRedBorder;
            Color borderColor = useRedBorder ? appTheme.primary50Color : appTheme.transparentColor;

            return ItemInfoListWidget(
              name: teacher.fullName ?? '',
              role: teacher.system == 1
                  ? 'Quản trị viên'
                  : teacher.system == 2
                      ? 'Quản lý'
                      : teacher.system == 3
                          ? 'Giáo viên'
                          : teacher.system == 4
                              ? 'Hệ thống'
                              : '',
              email: teacher.email ?? '',
              admin: teacher.grantedBy?.fullName ?? 'Admin',
              borderColor: borderColor,
              onTap: () {
                if (authController.teacherData.value?.system == 1 || authController.teacherData.value?.system == 2) {
                  showUpdateView(context, teacher);
                } else {
                  showNoSystemWidget(
                    context,
                    title: 'Bạn không có quyền quản lý',
                    des: 'Xin lỗi, bạn không có quyền truy cập chức năng của cấp quyền vai trò.',
                    cancel: 'Hủy',
                    confirm: 'Xác nhận',
                    ontap: () => Navigator.pop(context),
                  );
                }
              },
              onLongPressStart: (p0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeacherDetailScreen(teacher: teacher),
                  ),
                );
              },
            );
          }).toList(),
        ),
      );
    });
  }
}
