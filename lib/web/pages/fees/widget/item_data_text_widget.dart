import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';

Widget itemDataTextWidget(
  BuildContext context, {
  required VoidCallback deleteOnTap,
  required VoidCallback editOnTap,
  required String searchCode,
  required String content,
  required String soTienPhatHanh,
  required String soTienDong,
  required String hanDongTien,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: appTheme.whiteColor,
      border: Border.all(color: appTheme.strokeColor),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: Responsive.isMobile(context) ? 80 : MediaQuery.of(context).size.width / 12,
            child: Text(
              searchCode,
              style: StyleThemeData.styleSize14Weight500(),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 5,
            child: Text(
              content,
              style: StyleThemeData.styleSize14Weight500(),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 8,
            child: Text(
              NumberFormat.decimalPattern().format(int.parse(soTienPhatHanh)),
              style: StyleThemeData.styleSize14Weight500(),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 8,
            child: Text(
              NumberFormat.decimalPattern().format(int.parse(soTienDong)),
              style: StyleThemeData.styleSize14Weight500(),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: Responsive.isMobile(context) ? 80 : MediaQuery.of(context).size.width / 10,
            child: Text(
              hanDongTien,
              style: StyleThemeData.styleSize14Weight500(),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 8,
            child: Row(
              children: [
                InkWell(
                  onTap: deleteOnTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: appTheme.errorColor,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Xóa',
                          style: StyleThemeData.styleSize12Weight500(color: appTheme.whiteColor),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.clear, size: 12, color: appTheme.whiteColor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: editOnTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: appTheme.appColor,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Sửa',
                          style: StyleThemeData.styleSize12Weight500(color: appTheme.whiteColor),
                        ),
                        const SizedBox(width: 8),
                        SvgPicture.asset(IconAssets.editIcon),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
