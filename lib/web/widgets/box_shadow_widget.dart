import 'package:flutter/material.dart';
import 'package:school_web/main.dart';

class BoxShadowWidget extends StatelessWidget {
  const BoxShadowWidget({
    required this.child,
    this.radius = 8,
    this.padding,
    this.color,
    super.key,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? appTheme.whiteColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(
            color: Color(0x143A73C2),
            offset: Offset(0, 0),
            blurRadius: 8,
          ),
          BoxShadow(
            color: Color(0x143A73C2),
            offset: Offset(0, 0),
            blurRadius: 8,
          ),
        ],
      ),
      child: child,
    );
  }
}
