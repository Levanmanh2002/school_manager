import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/utils/assets/images.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/full_screen_image_screen.dart';

class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({required this.student, super.key});

  final Students student;

  @override
  Widget build(BuildContext context) {
    late bool isStudying = student.isStudying ?? true;

    final birthDateJson = student.birthDate.toString();

    final dateFormatter = DateFormat('dd/MM/yyyy');

    DateTime? birthDate;
    if (birthDateJson.isNotEmpty) {
      birthDate = DateTime.tryParse(birthDateJson);
    }

    final formattedBirthDate = birthDate != null ? dateFormatter.format(birthDate) : 'N/A';
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.blackColor),
        title: Text(
          student.fullName ?? '',
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
              children: [
                Responsive.isMobile(context)
                    ? const SizedBox.shrink()
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullImageWidget(imageUrl: student.avatarUrl),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(student.avatarUrl ??
                              'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512'),
                          radius: 80,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullImageWidget(imageUrl: student.avatarUrl),
                                  ),
                                );
                              },
                              // child: CircleAvatar(
                              //   backgroundImage: NetworkImage(student.avatarUrl ??
                              //       'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512'),
                              //   radius: 80,
                              // ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: CachedNetworkImage(
                                  imageUrl: student.avatarUrl.toString(),
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
                          _buildInfoItem('Mã số sinh viên', student.mssv ?? '', context),
                          _buildInfoItem('Tên sinh viên', student.fullName ?? '', context),
                          _buildInfoItem('Gmail', student.gmail ?? '', context),
                          _buildInfoItem('Số điện thoại', student.phone ?? '', context),
                          _buildInfoItem('Căn cước công dân', student.cccd ?? '', context),
                          _buildInfoItem('Giới tính', student.gender ?? '', context),
                          _buildInfoItem('Ngày sinh', formattedBirthDate, context),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: const Text(
                              '2. Địa chỉ',
                              style: TextStyle(color: AppColors.blackColor, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          _buildInfoItem('Địa chỉ', student.address ?? '', context),
                          _buildInfoItem('Thành phố', student.city ?? '', context),
                          _buildInfoItem('Quận/Huyện', student.district ?? '', context),
                          _buildInfoItem('Phường/Xã', student.ward ?? '', context),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: const Text(
                              '3. Quá trình học',
                              style: TextStyle(color: AppColors.blackColor, fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ),
                          // _buildInfoItem('Trình độ học vấn', student.educationLevel ?? '', context),
                          // _buildInfoItem('Học lực học sinh', student.academicPerformance ?? '', context),
                          // _buildInfoItem('Hạnh kiểm học sinh', student.conduct ?? '', context),
                          // _buildInfoItem('học lực lớp 10', student.classRanking10 ?? '', context),
                          // _buildInfoItem('học lực lớp 11', student.classRanking11 ?? '', context),
                          // _buildInfoItem('học lực lớp 12', student.classRanking12 ?? '', context),
                          // _buildInfoItem('Năm tốt nghiệp', student.graduationYear ?? '', context),
                          _buildInfoItem(
                            'Tình trạng học sinh',
                            isStudying ? 'Học sinh đang học' : 'Học sinh đã nghỉ học',
                            context,
                          ),
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
