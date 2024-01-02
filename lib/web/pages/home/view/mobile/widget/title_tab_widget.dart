// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';

Widget titleTabWidget({required String name, required String code, required String industry, required String email, required String phone, required String status, required String detail}) {
  return  Padding(
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
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7E8695),
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
                code,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7E8695),
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
                industry,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7E8695),
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
                email,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7E8695),
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
                phone,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7E8695),
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
                status,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7E8695),
                  height: 1.5,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              // constraints: const BoxConstraints(maxWidth: 80),
              width: 80,
              child: Text(
                detail,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF7E8695),
                  height: 1.5,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
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
