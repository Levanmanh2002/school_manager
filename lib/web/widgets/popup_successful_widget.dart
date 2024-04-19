import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';

void popupSuccessfulWidget(
  BuildContext context, {
  required String title,
  required String des,
  required String cancel,
  required String confirm,
  required VoidCallback ontapCancel,
  required VoidCallback ontapConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            SvgPicture.asset(IconAssets.successIcon),
            const SizedBox(height: 2),
            Text(title, style: StyleThemeData.styleSize14Weight600()),
            const SizedBox(height: 8),
            Text(des, style: StyleThemeData.styleSize14Weight400(), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: InkWell(
                    onTap: ontapCancel,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: appTheme.appColor),
                      ),
                      child: Text(
                        cancel,
                        style: StyleThemeData.styleSize14Weight700(color: appTheme.appColor),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: InkWell(
                    onTap: ontapConfirm,
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: appTheme.appColor,
                      ),
                      child: Text(
                        confirm,
                        style: StyleThemeData.styleSize14Weight700(color: appTheme.whiteColor),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    },
  );
}
