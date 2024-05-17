import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/utils/assets/images.dart';
import 'package:school_web/web/widgets/box_shadow_widget.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/full_screen_image_screen.dart';

class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({required this.student, super.key});

  final Students student;

  @override
  Widget build(BuildContext context) {
    final birthDateJson = student.birthDate.toString();

    final dateFormatter = DateFormat('dd/MM/yyyy');

    DateTime? birthDate;
    if (birthDateJson.isNotEmpty) {
      birthDate = DateTime.tryParse(birthDateJson);
    }

    final formattedBirthDate = birthDate != null ? dateFormatter.format(birthDate) : 'N/A';

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
                  'Thông tin học sinh',
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
                              fullImageWidget(context, student.avatarUrl ?? '');
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: CachedNetworkImage(
                                imageUrl: student.avatarUrl ?? '',
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
                                    fullImageWidget(context, student.avatarUrl ?? '');
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(1000),
                                    child: CachedNetworkImage(
                                      imageUrl: student.avatarUrl.toString(),
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
                                    title: 'Mã số sinh viên',
                                    initialData: student.mssv ?? 'N/A',
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
                                    initialData: student.fullName ?? 'N/A',
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
                                    initialData: student.gmail ?? 'N/A',
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
                                    initialData: student.phone ?? 'N/A',
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
                                    initialData: student.cccd ?? 'N/A',
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
                                    initialData: student.gender ?? 'N/A',
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
                                    title: 'Năm sinh',
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
                                    title: 'Đối tượng',
                                    initialData: student.beneficiary ?? 'N/A',
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
                                    initialData: student.address ?? 'N/A',
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
                                    initialData: student.city ?? 'N/A',
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
                                    initialData: student.district ?? 'N/A',
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
                                    initialData: student.ward ?? 'N/A',
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
                            '3. Thông tin liên hệ',
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
                                    title: 'Dân tộc',
                                    initialData: student.ethnicity ?? 'N/A',
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
                                    title: 'Họ tên Cha',
                                    initialData: student.fatherFullName ?? 'N/A',
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
                                    title: 'Họ tên Mẹ',
                                    initialData: student.motherFullName ?? 'N/A',
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
                                    title: 'Số liên hệ',
                                    initialData: student.contactPhone ?? 'N/A',
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
                                    title: 'Địa chỉ liên hệ',
                                    initialData: student.contactAddress ?? 'N/A',
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
                                    title: 'Ghi chú',
                                    initialData: student.notes ?? 'N/A',
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

  Widget _buildInfoItem(String label, String value, BuildContext context) {
    return SizedBox(
      width: Responsive.isMobile(context) ? null : 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextWidgets(
            title: label,
            initialData: value,
            enabled: false,
            colorHint: AppColors.blackColor,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
