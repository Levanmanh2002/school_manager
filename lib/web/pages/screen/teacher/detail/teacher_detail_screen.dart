import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/utils/assets/images.dart';
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

    late bool isSeletedIsWorking = teacher.isWorking ?? false;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.blackColor),
        title: Text(
          teacher.fullName ?? '',
          style: const TextStyle(color: AppColors.blackColor, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Responsive.isMobile(context)
              ? const EdgeInsets.only(left: 24, right: 24, bottom: 36)
              : const EdgeInsets.only(left: 24 + 24, right: 24 + 24, bottom: 48),
          child: Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
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
                    mainAxisAlignment: MainAxisAlignment.start,
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
                      Wrap(
                        spacing: 12,
                        runSpacing: Responsive.isMobile(context) ? 12 : 32,
                        runAlignment: WrapAlignment.center,
                        alignment: WrapAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: const Text(
                              '1. Thông tin chung',
                              style: TextStyle(color: AppColors.blackColor, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          _buildInfoItem(context, 'Mã giáo viên', teacher.teacherCode ?? ''),
                          _buildInfoItem(context, 'Họ và Tên', teacher.fullName ?? ''),
                          _buildInfoItem(context, 'Ngày sinh', formattedBirthDate),
                          _buildInfoItem(context, 'Email', teacher.email ?? ''),
                          _buildInfoItem(context, 'Số điện thoại', teacher.phoneNumber ?? ''),
                          _buildInfoItem(context, 'CCCD', teacher.cccd ?? ''),
                          _buildInfoItem(context, 'Giới tính', teacher.gender ?? ''),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: const Text(
                              '2. Địa chỉ',
                              style: TextStyle(color: AppColors.blackColor, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          _buildInfoItem(context, 'Địa chỉ', teacher.address ?? ''),
                          _buildInfoItem(context, 'Thành phố', teacher.city ?? ''),
                          _buildInfoItem(context, 'Quận/Huyện', teacher.district ?? ''),
                          _buildInfoItem(context, 'Phường/Xã', teacher.ward ?? ''),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: const Text(
                              '3. Trình độ chuyên môn',
                              style: TextStyle(color: AppColors.blackColor, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          _buildInfoItem(context, 'Trình độ học vấn', teacher.academicDegree ?? ''),
                          _buildInfoItem(context, 'Kinh nghiệm', teacher.experience ?? ''),
                          _buildInfoItem(context, 'Ngày tham gia', formattedJoinDate),
                          _buildInfoItem(context, 'Loại hợp đồng', teacher.contractType ?? ''),
                          _buildInfoItem(
                              context, 'Đang làm việc', isSeletedIsWorking ? 'Đang làm việc' : 'Đã nghỉ làm'),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
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
