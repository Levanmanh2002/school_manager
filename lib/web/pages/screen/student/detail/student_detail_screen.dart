import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/full_screen_image_screen.dart';

class StudentDetailScreen extends StatelessWidget {
  const StudentDetailScreen({required this.student, super.key});

  final StudentData student;

  @override
  Widget build(BuildContext context) {
    late bool isStudying = student.isStudying ?? true;

    final birthDateJson = student.birthDate.toString();
    final idCardIssuedDateJson = student.idCardIssuedDate.toString();

    final dateFormatter = DateFormat('dd/MM/yyyy');

    DateTime? birthDate;
    if (birthDateJson.isNotEmpty) {
      birthDate = DateTime.tryParse(birthDateJson);
    }

    DateTime? idCardIssuedDate;
    if (idCardIssuedDateJson.isNotEmpty) {
      idCardIssuedDate = DateTime.tryParse(idCardIssuedDateJson);
    }

    final formattedBirthDate = birthDate != null ? dateFormatter.format(birthDate) : 'N/A';
    final formCardIssuedDate = idCardIssuedDate != null ? dateFormatter.format(idCardIssuedDate) : 'N/A';
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          student.fullName ?? '',
          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageScreen(
                        imageUrl: student.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png',
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(student.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png'),
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
                  _buildInfoItem('Mã số sinh viên', student.mssv ?? '', context),
                  _buildInfoItem('Tên sinh viên', student.fullName ?? '', context),
                  _buildInfoItem('Gmail', student.gmail ?? '', context),
                  _buildInfoItem('Số điện thoại', student.phone ?? '', context),
                  _buildInfoItem('Năm sinh học sinh', formattedBirthDate, context),
                  _buildInfoItem('Căn cước công dân', student.cccd ?? '', context),
                  _buildInfoItem('Ngày cấp cmnd', formCardIssuedDate, context),
                  _buildInfoItem('Nơi cấp cmnd', student.idCardIssuedPlace ?? '', context),
                  _buildInfoItem('Nơi sinh học sinh', student.birthPlace ?? '', context),
                  _buildInfoItem('Năm vào học', student.customYear ?? '', context),
                  _buildInfoItem('Giới tính học sinh', student.gender ?? '', context),
                  _buildInfoItem('Quê quán học sinh', student.hometown ?? '', context),
                  _buildInfoItem('Địa chỉ thường trú học sinh', student.permanentAddress ?? '', context),
                  _buildInfoItem('Dân tộc học sinh', student.ethnicity ?? '', context),
                  _buildInfoItem('Tôn giáo học sinh', student.religion ?? '', context),
                  _buildInfoItem('Ghi chú', student.notes ?? '', context),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: const Text(
                      '2. Trình độ học vấn',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  _buildInfoItem('Nghề nghiệp học sinh', student.occupation ?? '', context),
                  _buildInfoItem('Trình độ học vấn', student.educationLevel ?? '', context),
                  _buildInfoItem('Học lực học sinh', student.academicPerformance ?? '', context),
                  _buildInfoItem('Hạnh kiểm học sinh', student.conduct ?? '', context),
                  _buildInfoItem('học lực lớp 10', student.classRanking10 ?? '', context),
                  _buildInfoItem('học lực lớp 11', student.classRanking11 ?? '', context),
                  _buildInfoItem('học lực lớp 12', student.classRanking12 ?? '', context),
                  _buildInfoItem('Năm tốt nghiệp', student.graduationYear ?? '', context),
                  _buildInfoItem('Đối tượng học sinh (khu vực nào)', student.beneficiary ?? '', context),
                  _buildInfoItem('Khu vực', student.area ?? '', context),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: const Text(
                      '3. Thông tin liên hệ',
                      style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  _buildInfoItem('Số điện thoại liên lạc', student.contactPhone ?? '', context),
                  _buildInfoItem('Địa chỉ liên lạc', student.contactAddress ?? '', context),
                  _buildInfoItem('Họ tên Cha', student.fatherFullName ?? '', context),
                  _buildInfoItem('Họ tên Mẹ', student.motherFullName ?? '', context),
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
            colorHint: Colors.black,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
