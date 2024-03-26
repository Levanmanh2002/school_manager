// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/pages/screen/student/detail/student_detail_screen.dart';

Widget tableInfoStudentWidget(Students studentData, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              // constraints: const BoxConstraints(maxWidth: 200),
              width: 200,
              child: Text(
                studentData.fullName ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF373743),
                  height: 1.5,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              // constraints: const BoxConstraints(maxWidth: 100),
              width: 100,
              child: Text(
                studentData.mssv ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF373743),
                  height: 1.5,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              // constraints: const BoxConstraints(maxWidth: 110),
              width: 110,
              child: Text(
                studentData.major?.name ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF373743),
                  height: 1.5,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              // constraints: const BoxConstraints(maxWidth: 200),
              width: 200,
              child: Text(
                studentData.gmail ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF373743),
                  height: 1.5,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              // constraints: const BoxConstraints(maxWidth: 100),
              width: 100,
              child: Text(
                studentData.phone ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF373743),
                  height: 1.5,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              // constraints: const BoxConstraints(maxWidth: 110),
              width: 110,
              child: Text(
                studentData.status == 1
                    ? 'Đang học'
                    : studentData.status == 2
                        ? 'Nghỉ học'
                        : studentData.status == 3
                            ? 'Đình chỉ'
                            : studentData.status == 4
                                ? 'Bị đuổi học'
                                : '',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: studentData.status == 1
                      ? appTheme.successColor
                      : studentData.status == 2
                          ? appTheme.yellow500Color
                          : studentData.status == 3
                              ? appTheme.neutral40Color
                              : studentData.status == 4
                                  ? appTheme.errorColor
                                  : appTheme.successColor,
                  height: 1.5,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDetailScreen(student: studentData),
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
