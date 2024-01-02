import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget itemPaginationWidget() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SvgPicture.asset('assets/icons/caret_double_left.svg'),
        const SizedBox(width: 8),
        SvgPicture.asset('assets/icons/caret_left.svg'),
        const SizedBox(width: 8),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xFFF5F9FF),
          ),
          child: const Text(
            '1',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1F5BEF),
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const SizedBox(
          width: 24,
          height: 24,
          child: Text(
            '2',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF9AA0AC),
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SvgPicture.asset('assets/icons/caret_right.svg'),
        const SizedBox(width: 8),
        SvgPicture.asset('assets/icons/caret_double_right.svg'),
        const SizedBox(width: 24),
        const Text(
          'Hiển thị 1 - 10 / Tổng số 20 kết quả',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF7E8695),
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}
