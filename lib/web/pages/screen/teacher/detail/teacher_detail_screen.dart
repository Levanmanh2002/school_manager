import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
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

    late bool isCivilServant = teacher.civilServant ?? true;
    late bool isSeletedIsWorking = teacher.isWorking ?? false;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          teacher.fullName ?? '',
          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageScreen(
                        imageUrl: teacher.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png',
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(teacher.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png'),
                  radius: 80,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 12,
                runSpacing: Responsive.isMobile(context) ? 12 : 32,
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: const Text(
                      '1. Thông tin chung',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  _buildInfoItem(context, 'Mã giáo viên', teacher.teacherCode ?? ''),
                  _buildInfoItem(context, 'Họ và Tên', teacher.fullName ?? ''),
                  _buildInfoItem(context, 'Ngày sinh', formattedBirthDate),
                  _buildInfoItem(context, 'Email', teacher.email ?? ''),
                  _buildInfoItem(context, 'Số điện thoại', teacher.phoneNumber ?? ''),
                  _buildInfoItem(context, 'Giới tính', teacher.gender ?? ''),
                  _buildInfoItem(context, 'CCCD', teacher.cccd ?? ''),
                  _buildInfoItem(context, 'Nơi sinh', teacher.birthPlace ?? ''),
                  _buildInfoItem(context, 'Dân tộc', teacher.ethnicity ?? ''),
                  _buildInfoItem(context, 'Biệt danh', teacher.nickname ?? ''),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: const Text(
                      '2. Thông tin công việc',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  _buildInfoItem(context, 'Trình độ giảng dạy', teacher.teachingLevel ?? ''),
                  _buildInfoItem(context, 'Vị trí', teacher.position ?? ''),
                  _buildInfoItem(context, 'Kinh nghiệm', teacher.experience ?? ''),
                  _buildInfoItem(context, 'Bộ môn', teacher.department ?? ''),
                  _buildInfoItem(context, 'Chức vụ', teacher.role ?? ''),
                  _buildInfoItem(context, 'Ngày tham gia', formattedJoinDate),
                  _buildInfoItem(context, 'Là cán bộ công chức', isCivilServant ? 'Có' : 'Không'),
                  _buildInfoItem(context, 'Loại hợp đồng', teacher.contractType ?? ''),
                  _buildInfoItem(context, 'Môn học chính', teacher.primarySubject ?? ''),
                  _buildInfoItem(context, 'Môn học phụ', teacher.secondarySubject ?? ''),
                  _buildInfoItem(context, 'Đang làm việc', isSeletedIsWorking ? 'Đang làm việc' : 'Đã nghỉ làm'),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: const Text(
                      '3. Trình độ chuyên môn',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  _buildInfoItem(context, 'Trình độ học vấn', teacher.academicDegree ?? ''),
                  _buildInfoItem(context, 'Trình độ chuẩn', teacher.standardDegree ?? ''),
                  _buildInfoItem(context, 'Lý thuyết chính trị', teacher.politicalTheory ?? ''),
                ],
              ),
              const SizedBox(height: 32),
            ],
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
            colorHint: Colors.black,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
