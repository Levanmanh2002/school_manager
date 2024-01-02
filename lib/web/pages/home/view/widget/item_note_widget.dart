import 'package:flutter/material.dart';

Widget itemNoteWidget({required Color borderColor, required String title, Color textColor = const Color(0xFF373743)}) {
  return Row(
    children: [
      Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: borderColor,
        ),
      ),
      const SizedBox(width: 8),
      Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: textColor),
      ),
    ],
  );
}
