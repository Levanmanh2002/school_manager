// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/pages/screen/teacher/detail/teacher_detail_screen.dart';

Widget tableInfoTeacherWidget(TeacherData teacherData, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: Text(
                teacherData.fullName ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF373743),
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                teacherData.teacherCode ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF373743),
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(
              width: 110,
              child: Text(
                teacherData.academicDegree ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF373743),
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(
              width: 200,
              child: Text(
                teacherData.email ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF373743),
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                teacherData.phoneNumber ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF373743),
                  height: 1.5,
                ),
              ),
            ),
            SizedBox(
              width: 110,
              child: Text(
                teacherData.isWorking == true ? 'Đang làm việc' : 'Đã nghỉ làm',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: teacherData.isWorking == true ? const Color(0xFF3A73C2) : const Color(0xFFFC8805),
                  height: 1.5,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeacherDetailScreen(teacher: teacherData),
                  ),
                );
              },
              child: Container(
                width: 80,
                padding: const EdgeInsets.all(12),
                child: SvgPicture.asset('assets/icons/pencil_simple_line.svg'),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(height: 0),
        ),
      ],
    ),
  );
}
