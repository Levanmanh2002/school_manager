import 'package:flutter/material.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/pages/screen/teacher/detail/teacher_detail_screen.dart';

Widget buildTeacherCard(TeacherData teacherData, BuildContext context) {
  return Column(
    children: [
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherDetailScreen(teacher: teacherData),
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
                    teacherData.avatarUrl ??
                        'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                  ),
                  radius: 30,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacherData.fullName ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF373743),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'MSGV: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF373743),
                              height: 1.5,
                            ),
                          ),
                          TextSpan(
                            text:
                                '${(teacherData.teacherCode ?? '')} ${teacherData.academicDegree!.isNotEmpty ? '-' : ''} ${teacherData.academicDegree ?? ''}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF3A73C2),
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
                            text: 'Trạng thái: ',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF373743),
                              height: 1.5,
                            ),
                          ),
                          TextSpan(
                            text: teacherData.isWorking == true ? 'Đang làm việc' : 'Đã nghỉ làm',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: teacherData.isWorking == true ? const Color(0xFF3A73C2) : const Color(0xFFFC8805),
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
                            text: teacherData.phoneNumber ?? '',
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
