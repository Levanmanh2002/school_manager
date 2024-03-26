import 'package:flutter/material.dart';
import 'package:school_web/web/style/style_theme.dart';

class StorageInfoCardData extends StatelessWidget {
  const StorageInfoCardData({
    required this.color,
    required this.title,
    this.width = 110,
    super.key,
  });

  final Color color;
  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          Icon(Icons.circle_rounded, color: color, size: 16),
          const SizedBox(width: 8),
          Text(
            title,
            style: StyleThemeData.styleSize14Weight400(height: 0),
          ),
        ],
      ),
    );
  }
}
