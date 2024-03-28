// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison, use_full_hex_values_for_flutter_colors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/routes/pages.dart';
import 'package:school_web/web/utils/assets/images.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/full_screen_image_screen.dart';

class ProfilePages extends StatefulWidget {
  const ProfilePages({super.key});

  @override
  State<ProfilePages> createState() => _ProfilePagesState();
}

class _ProfilePagesState extends State<ProfilePages> with SingleTickerProviderStateMixin {
  TeacherData? teacherData;
  final authController = Get.put(AuthenticationController());

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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.blackColor),
        title: const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Thông tin cá nhân',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Responsive.isMobile(context)
              ? const EdgeInsets.only(left: 24, right: 24, bottom: 36)
              : const EdgeInsets.only(left: 24 + 24, right: 24 + 24, bottom: 48),
          child: Container(
            padding: const EdgeInsets.all(24),
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
            child: Obx(
              () => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Responsive.isMobile(context)
                      ? const SizedBox.shrink()
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullImageWidget(
                                  imageUrl: authController.teacherData.value?.avatarUrl,
                                ),
                              ),
                            );
                          },
                          // child: CircleAvatar(
                          //   backgroundImage: NetworkImage(
                          //     authController.teacherData.value?.avatarUrl ??
                          //         'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                          //   ),
                          //   radius: 80,
                          // ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: CachedNetworkImage(
                              imageUrl: authController.teacherData.value?.avatarUrl.toString() ?? '',
                              width: 80,
                              height: 80,
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullImageWidget(
                                        imageUrl: authController.teacherData.value?.avatarUrl,
                                      ),
                                    ),
                                  );
                                },
                                // child: CircleAvatar(
                                //   backgroundImage: NetworkImage(
                                //     authController.teacherData.value?.avatarUrl ??
                                //         'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                                //   ),
                                //   radius: 80,
                                // ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(1000),
                                  child: CachedNetworkImage(
                                    imageUrl: authController.teacherData.value?.avatarUrl.toString() ?? '',
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) {
                                      return Image.asset(ImagesAssets.noUrlImage, fit: BoxFit.cover);
                                    },
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        Responsive.isMobile(context) ? const SizedBox(height: 16) : const SizedBox.shrink(),
                        const Text(
                          '1. Thông tin cá nhân',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.blackColor),
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
                                  title: 'Họ và Tên',
                                  initialData: authController.teacherData.value?.fullName,
                                  enabled: false,
                                  colorHint: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: Responsive.isMobile(context) ? null : 200,
                                child: CustomTextWidgets(
                                  title: 'Mã giáo viên',
                                  initialData: authController.teacherData.value?.teacherCode,
                                  enabled: false,
                                  colorHint: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: Responsive.isMobile(context) ? null : 200,
                                child: CustomTextWidgets(
                                  title: 'Email',
                                  initialData: authController.teacherData.value?.email,
                                  enabled: false,
                                  colorHint: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: Responsive.isMobile(context) ? null : 200,
                                child: CustomTextWidgets(
                                  title: 'CCCD',
                                  initialData: authController.teacherData.value?.cccd,
                                  enabled: false,
                                  colorHint: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: Responsive.isMobile(context) ? null : 200,
                                child: CustomTextWidgets(
                                  title: 'Số điện thoại',
                                  initialData: authController.teacherData.value?.phoneNumber,
                                  enabled: false,
                                  colorHint: Colors.black,
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
                                  colorHint: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          '2. Địa chỉ',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.blackColor),
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
                                  initialData: authController.teacherData.value?.address,
                                  enabled: false,
                                  colorHint: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: Responsive.isMobile(context) ? null : 200,
                                child: CustomTextWidgets(
                                  title: 'Thành phố',
                                  initialData: authController.teacherData.value?.city,
                                  enabled: false,
                                  colorHint: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: Responsive.isMobile(context) ? null : 200,
                                child: CustomTextWidgets(
                                  title: 'Quận/Huyện',
                                  initialData: authController.teacherData.value?.district,
                                  enabled: false,
                                  colorHint: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: Responsive.isMobile(context) ? null : 200,
                                child: CustomTextWidgets(
                                  title: 'Phường/Xã',
                                  initialData: authController.teacherData.value?.ward,
                                  enabled: false,
                                  colorHint: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          '3. Trình độ chuyên môn',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.blackColor),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: Responsive.isMobile(context) ? 12 : 32,
                            children: [
                              SizedBox(
                                width: Responsive.isMobile(context) ? null : MediaQuery.of(context).size.width / 4,
                                child: CustomTextWidgets(
                                  title: 'Học vấn',
                                  initialData: authController.teacherData.value?.academicDegree,
                                  enabled: false,
                                  colorHint: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: Responsive.isMobile(context) ? null : 200,
                                child: CustomTextWidgets(
                                  title: 'Kinh nghiệm giảng dạy',
                                  initialData: authController.teacherData.value?.experience,
                                  enabled: false,
                                  colorHint: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: Responsive.isMobile(context) ? null : 200,
                                child: CustomTextWidgets(
                                  title: 'Ngày tham gia',
                                  initialData: formattedJoinDate,
                                  enabled: false,
                                  colorHint: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: Responsive.isMobile(context) ? null : 200,
                                child: CustomTextWidgets(
                                  title: 'Loại hợp đồng',
                                  initialData: authController.teacherData.value?.contractType,
                                  enabled: false,
                                  colorHint: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: Responsive.isMobile(context) ? null : 200,
                                child: CustomTextWidgets(
                                  title: 'Đang làm việc',
                                  initialData: authController.teacherData.value?.isWorking == true
                                      ? 'Đang làm việc'
                                      : 'Đã nghỉ làm',
                                  enabled: false,
                                  colorHint: Colors.black,
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
                onTap: () {
                  Get.toNamed(Routes.EDITPROFILR);
                },
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryColor,
                  ),
                  child: const Text(
                    'Chỉnh sửa hồ sơ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.whiteColor),
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
