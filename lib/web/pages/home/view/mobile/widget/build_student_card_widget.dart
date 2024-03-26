// ignore_for_file: unrelated_type_equality_checks

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/screen/student/detail/student_detail_screen.dart';
import 'package:school_web/web/utils/assets/images.dart';

Widget buildStudentCard(Students studentData, BuildContext context) {
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
                // CircleAvatar(
                //   backgroundImage: NetworkImage(
                //     studentData.avatarUrl ??
                //         'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                //   ),
                //   radius: 30,
                // ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(1000),
                  child: CachedNetworkImage(
                    imageUrl: studentData.avatarUrl.toString(),
                    width: 46,
                    height: 46,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return Image.asset(ImagesAssets.noUrlImage, fit: BoxFit.cover);
                    },
                  ),
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
                            Responsive.isMobile(context) ? (studentData.mssv ?? '') : studentData.major?.name ?? '',
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
                            text: studentData.status == 1
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
