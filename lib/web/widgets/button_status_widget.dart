import 'package:flutter/material.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/style/style_theme.dart';

class ButtonStatusWidget extends StatelessWidget {
  const ButtonStatusWidget({
    required this.text,
    required this.data,
    required this.borderColor,
    this.color,
    super.key,
  });

  final String text;
  final Color? color;
  final String data;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: borderColor,
      ),
      child: Row(
        children: [
          Text('$text: ', style: StyleThemeData.styleSize12Weight500(color: color ?? appTheme.appColor, height: 0)),
          Text(data, style: StyleThemeData.styleSize12Weight500(color: color ?? appTheme.appColor, height: 0)),
        ],
      ),
    );
  }
}
