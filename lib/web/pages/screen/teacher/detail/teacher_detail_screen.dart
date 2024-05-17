import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/utils/assets/images.dart';
import 'package:school_web/web/widgets/box_shadow_widget.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/full_screen_image_screen.dart';

class TeacherDetailScreen extends StatelessWidget {
  const TeacherDetailScreen({required this.teacher, super.key});

  final TeacherData teacher;

  @override
  Widget build(BuildContext context) {
    final birthDateJson = teacher.birthDate.toString();
    final joinDateJson = teacher.joinDate.toString();

    final dateFormatter = DateFormat('dd/MM/yyyy');
    DateTime? birthDate;
    if (birthDateJson.isNotEmpty) {
      birthDate = DateTime.tryParse(birthDateJson);
    }

    DateTime? joinDate;
    if (joinDateJson.isNotEmpty) {
      joinDate = DateTime.tryParse(joinDateJson);
    }

    final formattedBirthDate = birthDate != null ? dateFormatter.format(birthDate) : 'N/A';
    final formattedJoinDate = joinDate != null ? dateFormatter.format(joinDate) : 'N/A';

    final colorHint = appTheme.blackColor;
    double borderRadius = 8;
    const height = 1.5;

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
                  'Thông tin giáo viên',
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Responsive.isMobile(context)
                        ? const SizedBox.shrink()
                        : GestureDetector(
                            onTap: () {
                              fullImageWidget(context, teacher.avatarUrl ?? '');
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: CachedNetworkImage(
                                imageUrl: teacher.avatarUrl.toString(),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Responsive.isMobile(context)
                              ? GestureDetector(
                                  onTap: () {
                                    fullImageWidget(context, teacher.avatarUrl ?? '');
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(1000),
                                    child: CachedNetworkImage(
                                      imageUrl: teacher.avatarUrl.toString(),
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
                            '1. Thông tin chung',
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
                                    initialData: teacher.teacherCode?.toUpperCase() ?? 'N/A',
                                    enabled: false,
                                    colorHint: colorHint,
                                    borderRadius: borderRadius,
                                    height: height,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: Responsive.isMobile(context) ? null : 200,
                                  child: CustomTextWidgets(
                                    title: 'Họ tên',
                                    initialData: teacher.fullName ?? 'N/A',
                                    enabled: false,
                                    colorHint: colorHint,
                                    borderRadius: borderRadius,
                                    height: height,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: Responsive.isMobile(context) ? null : 200,
                                  child: CustomTextWidgets(
                                    title: 'Ngày sinh',
                                    initialData: formattedBirthDate,
                                    enabled: false,
                                    colorHint: colorHint,
                                    borderRadius: borderRadius,
                                    height: height,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: Responsive.isMobile(context) ? null : 200,
                                  child: CustomTextWidgets(
                                    title: 'Email',
                                    initialData: teacher.email ?? 'N/A',
                                    enabled: false,
                                    colorHint: colorHint,
                                    borderRadius: borderRadius,
                                    height: height,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: Responsive.isMobile(context) ? null : 200,
                                  child: CustomTextWidgets(
                                    title: 'Số điện thoại',
                                    initialData: teacher.phoneNumber ?? 'N/A',
                                    enabled: false,
                                    colorHint: colorHint,
                                    borderRadius: borderRadius,
                                    height: height,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: Responsive.isMobile(context) ? null : 200,
                                  child: CustomTextWidgets(
                                    title: 'CCCD',
                                    initialData: teacher.cccd ?? 'N/A',
                                    enabled: false,
                                    colorHint: colorHint,
                                    borderRadius: borderRadius,
                                    height: height,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: Responsive.isMobile(context) ? null : 200,
                                  child: CustomTextWidgets(
                                    title: 'Giới tính',
                                    initialData: teacher.gender ?? 'N/A',
                                    enabled: false,
                                    colorHint: colorHint,
                                    borderRadius: borderRadius,
                                    height: height,
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
                                    initialData: teacher.address ?? 'N/A',
                                    enabled: false,
                                    colorHint: colorHint,
                                    borderRadius: borderRadius,
                                    height: height,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: Responsive.isMobile(context) ? null : 200,
                                  child: CustomTextWidgets(
                                    title: 'Thành phố',
                                    initialData: teacher.city ?? 'N/A',
                                    enabled: false,
                                    colorHint: colorHint,
                                    borderRadius: borderRadius,
                                    height: height,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: Responsive.isMobile(context) ? null : 200,
                                  child: CustomTextWidgets(
                                    title: 'Quận/Huyện',
                                    initialData: teacher.district ?? 'N/A',
                                    enabled: false,
                                    colorHint: colorHint,
                                    borderRadius: borderRadius,
                                    height: height,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: Responsive.isMobile(context) ? null : 200,
                                  child: CustomTextWidgets(
                                    title: 'Phường/Xã',
                                    initialData: teacher.ward ?? 'N/A',
                                    enabled: false,
                                    colorHint: colorHint,
                                    borderRadius: borderRadius,
                                    height: height,
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
                                    initialData: teacher.academicDegree ?? 'N/A',
                                    enabled: false,
                                    colorHint: colorHint,
                                    borderRadius: borderRadius,
                                    height: height,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: Responsive.isMobile(context) ? null : 200,
                                  child: CustomTextWidgets(
                                    title: 'Kinh nghiệm',
                                    initialData: teacher.experience ?? 'N/A',
                                    enabled: false,
                                    colorHint: colorHint,
                                    borderRadius: borderRadius,
                                    height: height,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: Responsive.isMobile(context) ? null : 200,
                                  child: CustomTextWidgets(
                                    title: 'Chức vụ',
                                    initialData: teacher.position ?? 'N/A',
                                    enabled: false,
                                    colorHint: colorHint,
                                    borderRadius: borderRadius,
                                    height: height,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: Responsive.isMobile(context) ? null : 200,
                                  child: CustomTextWidgets(
                                    title: 'Loại hợp đồng',
                                    initialData: teacher.contractType ?? 'N/A',
                                    enabled: false,
                                    colorHint: colorHint,
                                    borderRadius: borderRadius,
                                    height: height,
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
                                    height: height,
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
            ],
          ),
        ),
      ),
    );
  }
}
