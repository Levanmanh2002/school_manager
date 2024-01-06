// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/screen/student/detail/student_detail_screen.dart';

Widget buildStudentCard(StudentData studentData, BuildContext context) {
  String phone = studentData.phone ?? '';
  String displayedPhone = phone.length > 12 ? '${phone.substring(0, 12)}...' : phone;

  return Column(
    children: [
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentDetailScreen(student: studentData),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    studentData.avatarUrl ??
                        'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                  ),
                  radius: 30,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studentData.fullName ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF373743),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          'MSSV: ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF373743),
                            height: 1.5,
                          ),
                        ),
                        Container(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Text(
                            Responsive.isMobile(context)
                                ? (studentData.mssv ?? '')
                                : '${(studentData.mssv ?? '')} ${studentData.occupation!.isNotEmpty ? '-' : ''} ${studentData.occupation ?? ''}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF3A73C2),
                              height: 1.5,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Trạng thái: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF373743),
                              height: 1.5,
                            ),
                          ),
                          TextSpan(
                            text: studentData.isStudying == true
                                ? 'Đang học'
                                : studentData.selfSuspension == true
                                    ? 'Nghỉ học'
                                    : studentData.suspension == true
                                        ? 'Đình chỉ'
                                        : studentData.expulsion == true
                                            ? 'Bị đuổi học'
                                            : 'Đang học',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: studentData.isStudying == true
                                  ? const Color(0xFF3BB53B)
                                  : studentData.selfSuspension == true
                                      ? const Color(0xFFFC8805)
                                      : studentData.suspension == true
                                          ? const Color(0xFF9AA0AC)
                                          : studentData.expulsion == true
                                              ? const Color(0xFFFC423F)
                                              : const Color(0xFF3BB53B),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Số điện thoại: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF373743),
                              height: 1.5,
                            ),
                          ),
                          TextSpan(
                            text: displayedPhone,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF373743),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 24,
              color: Color(0xFF3A73C2),
            ),
          ],
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Divider(height: 0),
      ),
    ],
  );
}
