import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/controllers/system/system_controller.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/system/widget/item_info_list_widget.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/status/status.dart';
import 'package:school_web/web/widgets/box_shadow_widget.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

List<Map<String, dynamic>> roles = [
  {'id': '1', 'name': 'Quản trị viên'},
  {'id': '2', 'name': 'Quản lý'},
  {'id': '3', 'name': 'Giáo viên'},
  {'id': '4', 'name': 'Hệ thống'}
];

void showUpdateView(BuildContext context, TeacherData teacher) {
  final SystemController systemController = Get.put(SystemController());
  final AuthController authController = Get.put(AuthController());

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Container(
          constraints: BoxConstraints(maxWidth: Responsive.isMobile(context) ? 311 : 500),
          child: Column(
            children: [
              BoxShadowWidget(
                child: ItemInfoListWidget(
                  code: teacher.teacherCode,
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
                  phone: teacher.phoneNumber,
                  admin: teacher.grantedBy?.fullName ?? 'Admin',
                  showIcon: false,
                  borderColor: appTheme.primary50Color,
                  borderRadius: 8,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => BoxShadowWidget(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: appTheme.strokeColor),
                        ),
                        child: Center(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              isExpanded: true,
                              hint: Text(
                                'Chọn quyền hạn',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: roles
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item['id'],
                                        child: Text(
                                          item['name'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: systemController.selectedValue.value.isEmpty
                                  ? null
                                  : systemController.selectedValue.value,
                              onChanged: (value) {
                                if (value != null) {
                                  systemController.selectedValue.value = value;
                                  systemController.roleDescription = getRoleDescription(value.toString());
                                }
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
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (systemController.roleDescription.isNotEmpty)
                        Text(systemController.roleDescription, style: StyleThemeData.styleSize14Weight400()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      showNoSystemWidget(
                        context,
                        title: 'Xác nhận hủy?',
                        des: 'Bạn có chắc chắn muốn hủy và không thể lưu thông tin chỉnh sửa?',
                        cancel: 'Đóng',
                        confirm: 'Đồng ý',
                        ontap: () {
                          systemController.selectedValue.value = '';
                          systemController.roleDescription = '';
                          Get.back();
                          Get.back();
                        },
                      );
                    },
                    child: Container(
                      height: 35,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: appTheme.appColor),
                      ),
                      child: Text(
                        'Hủy',
                        style: StyleThemeData.styleSize14Weight700(color: appTheme.appColor, height: 0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Obx(
                    () => InkWell(
                      onTap: () {
                        if (teacher.sId != null) {
                          if (systemController.selectedValue.value.isNotEmpty) {
                            systemController.updateSystem(
                              teacherId: teacher.sId.toString(),
                              system: systemController.selectedValue.value,
                              user: teacher.fullName.toString(),
                              grantedById: authController.teacherData.value!.sId.toString(),
                            );
                          } else {
                            showFailStatus('Vui lòng chọn quyền muốn cấp');
                          }
                        } else {
                          showFailStatus('Hệ thống đang bị lỗi, hãy quay lại sau');
                        }
                      },
                      child: Opacity(
                        opacity: systemController.selectedValue.isEmpty ? 0.5 : 1,
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 110),
                          height: 35,
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: appTheme.appColor,
                          ),
                          child: systemController.isLoading.isTrue
                              ? Center(
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(color: appTheme.whiteColor),
                                  ),
                                )
                              : Text(
                                  'Xác nhận',
                                  style: StyleThemeData.styleSize14Weight700(color: appTheme.whiteColor, height: 0),
                                ),
                        ),
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

String getRoleDescription(String roleId) {
  switch (roleId) {
    case '1':
      return 'Quản trị viên: có quyền cao nhất trong hệ thống, có thể quản lý và điều khiển toàn bộ hệ thống.';
    case '2':
      return 'Quản lý: quản lý nhóm hoặc phòng ban trong hệ thống, có thể quản lý thành viên và các hoạt động của nhóm.';
    case '3':
      return 'Giáo viên: có quyền quản lý và điều hành hoạt động giảng dạy, bao gồm giao bài tập, nhập điểm, v.v.';
    case '4':
      return 'Hệ thống: có quyền thực hiện các tác vụ hệ thống đặc biệt, chẳng hạn như cài đặt, bảo trì, v.v.';
    default:
      return '';
  }
}
