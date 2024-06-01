// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison, use_full_hex_values_for_flutter_colors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/dashboard/controller/side_bar_controller.dart';
import 'package:school_web/web/utils/assets/images.dart';
import 'package:school_web/web/widgets/box_shadow_widget.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/full_screen_image_screen.dart';

class ProfilePages extends StatefulWidget {
  const ProfilePages({super.key});

  @override
  State<ProfilePages> createState() => _ProfilePagesState();
}

class _ProfilePagesState extends State<ProfilePages> with SingleTickerProviderStateMixin {
  final SideBarController sideBarController = Get.put(SideBarController());
  final authController = Get.put(AuthController());

  @override
  void initState() {
    authController.getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final birthDateJson = authController.teacherData.value?.birthDate;
    final joinDateJson = authController.teacherData.value?.joinDate;

    final dateFormatter = DateFormat('dd/MM/yyyy');
    DateTime? birthDate;
    if (birthDateJson != null && birthDateJson.isNotEmpty) {
      birthDate = DateTime.tryParse(birthDateJson);
    }

    DateTime? joinDate;
    if (joinDateJson != null && joinDateJson.isNotEmpty) {
      joinDate = DateTime.tryParse(joinDateJson);
    }

    final formattedBirthDate = birthDate != null ? dateFormatter.format(birthDate) : 'N/A';
    final formattedJoinDate = joinDate != null ? dateFormatter.format(joinDate) : 'N/A';

    final colorHint = appTheme.blackColor;
    double borderRadius = 8;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: Responsive.isMobile(context)
              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 24)
              : const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Thông tin cá nhân',
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context) ? 18 : 24,
                    fontWeight: FontWeight.w600,
                    color: appTheme.blackColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              BoxShadowWidget(
                padding: const EdgeInsets.all(24),
                child: Obx(
                  () => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Responsive.isMobile(context)
                          ? const SizedBox.shrink()
                          : GestureDetector(
                              onTap: () {
                                fullImageWidget(
                                  context,
                                  authController.teacherData.value?.avatarUrl ?? '',
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: CachedNetworkImage(
                                  imageUrl: authController.teacherData.value?.avatarUrl.toString() ?? '',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) {
                                    return Image.asset(ImagesAssets.noUrlImage, fit: BoxFit.cover);
                                  },
                                ),
                              ),
                            ),
                      Responsive.isMobile(context) ? const SizedBox.shrink() : const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              Responsive.isMobile(context) ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                          children: [
                            Responsive.isMobile(context)
                                ? GestureDetector(
                                    onTap: () {
                                      fullImageWidget(
                                        context,
                                        authController.teacherData.value?.avatarUrl ?? '',
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1000),
                                      child: CachedNetworkImage(
                                        imageUrl: authController.teacherData.value?.avatarUrl.toString() ?? '',
                                        width: 150,
                                        height: 150,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) {
                                          return Image.asset(ImagesAssets.noUrlImage, fit: BoxFit.cover);
                                        },
                                      ),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            Responsive.isMobile(context) ? const SizedBox(height: 16) : const SizedBox.shrink(),
                            Text(
                              '1. Thông tin cá nhân',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: appTheme.blackColor),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Wrap(
                                spacing: 12,
                                runSpacing: Responsive.isMobile(context) ? 12 : 32,
                                children: [
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'Mã giáo viên',
                                      initialData: authController.teacherData.value?.teacherCode,
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'Họ và Tên',
                                      initialData: authController.teacherData.value?.fullName,
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'Email',
                                      initialData: authController.teacherData.value?.email,
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'Ngày sinh',
                                      keyboardType: TextInputType.datetime,
                                      initialData: formattedBirthDate,
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'CCCD',
                                      initialData: authController.teacherData.value?.cccd,
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'Số điện thoại',
                                      initialData: authController.teacherData.value?.phoneNumber,
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'Giới tính',
                                      initialData: authController.teacherData.value?.gender,
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              '2. Địa chỉ',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: appTheme.blackColor),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Wrap(
                                spacing: 12,
                                runSpacing: Responsive.isMobile(context) ? 12 : 32,
                                children: [
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'Địa chỉ',
                                      initialData: authController.teacherData.value?.address ?? 'N/A',
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'Thành phố',
                                      initialData: authController.teacherData.value?.city ?? 'N/A',
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'Quận/Huyện',
                                      initialData: authController.teacherData.value?.district ?? 'N/A',
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'Phường/Xã',
                                      initialData: authController.teacherData.value?.ward ?? 'N/A',
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              '3. Trình độ chuyên môn',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: appTheme.blackColor),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Wrap(
                                spacing: 12,
                                runSpacing: Responsive.isMobile(context) ? 12 : 32,
                                children: [
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'Học vấn',
                                      initialData: authController.teacherData.value?.academicDegree ?? '',
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'Kinh nghiệm',
                                      initialData: authController.teacherData.value?.experience ?? '',
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'Chức vụ',
                                      initialData: authController.teacherData.value?.position ?? '',
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'Loại hợp đồng',
                                      initialData: authController.teacherData.value?.contractType ?? '',
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: Responsive.isMobile(context) ? null : 200,
                                    child: CustomTextWidgets(
                                      title: 'Ngày tham gia',
                                      initialData: formattedJoinDate,
                                      enabled: false,
                                      colorHint: colorHint,
                                      borderRadius: borderRadius,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => sideBarController.index.value = 13,
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: appTheme.appColor,
                  ),
                  child: Text(
                    'Chỉnh sửa hồ sơ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: appTheme.whiteColor),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
