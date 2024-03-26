import 'package:flutter/material.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/widgets/custom_text.dart';

class OnTaputtonWidget extends StatelessWidget {
  const OnTaputtonWidget({
    required this.isLoading,
    required this.onTap,
    this.width = double.maxFinite,
    this.vertical = 16,
    this.text = 'Tiếp tục',
    this.size = 16,
    this.colorLoading,
    super.key,
  });

  final double width;
  final double vertical;
  final bool isLoading;
  final String text;
  final VoidCallback onTap;
  final double size;
  final Color? colorLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(vertical: vertical),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: appTheme.appColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: size,
                  height: size,
                  child: CircularProgressIndicator(color: colorLoading ?? appTheme.whiteColor),
                ),
              )
            : CustomText(text: text, color: appTheme.whiteColor),
      ),
    );
  }
}
