import 'package:flutter/material.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/style/style_theme.dart';

Widget itemTextWidget(BuildContext context, {bool showStatus = false, bool showAct = true, bool dataTime = true}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    decoration: BoxDecoration(
      color: appTheme.appColor,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: Responsive.isMobile(context) ? 80 : MediaQuery.of(context).size.width / 12,
            child: Text(
              'Mã tra cứu',
              style: StyleThemeData.styleSize14Weight500(color: appTheme.whiteColor),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 5,
            child: Text(
              'Nội dung',
              style: StyleThemeData.styleSize14Weight500(color: appTheme.whiteColor),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 8,
            child: Text(
              'Số tiền phát hành',
              style: StyleThemeData.styleSize14Weight500(color: appTheme.whiteColor),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 8,
            child: Text(
              'Số tiền phải đóng',
              style: StyleThemeData.styleSize14Weight500(color: appTheme.whiteColor),
            ),
          ),
          if (showStatus) const SizedBox(width: 8),
          if (showStatus)
            SizedBox(
              width: Responsive.isMobile(context) ? 80 : MediaQuery.of(context).size.width / 10,
              child: Text(
                dataTime ? 'Trạng thái' : 'Phương thức thanh toán',
                style: StyleThemeData.styleSize14Weight500(color: appTheme.whiteColor),
              ),
            ),
          const SizedBox(width: 8),
          SizedBox(
            width: Responsive.isMobile(context) ? 80 : MediaQuery.of(context).size.width / 10,
            child: Text(
              dataTime ? 'Hạn đóng' : 'Ngày đóng tiền',
              style: StyleThemeData.styleSize14Weight500(color: appTheme.whiteColor),
            ),
          ),
          if (showAct) const SizedBox(width: 8),
          if (showAct)
            SizedBox(
              width: Responsive.isMobile(context) ? 150 : MediaQuery.of(context).size.width / 8,
              child: Text(
                'Hành động',
                style: StyleThemeData.styleSize14Weight500(color: appTheme.whiteColor),
              ),
            ),
        ],
      ),
    ),
  );
}
