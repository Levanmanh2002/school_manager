import 'package:flutter/material.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/style/style_theme.dart';

class ItemInfoListWidget extends StatelessWidget {
  const ItemInfoListWidget({
    required this.name,
    required this.role,
    required this.email,
    required this.admin,
    this.code,
    this.phone,
    this.borderColor,
    required this.onTap,
    this.onLongPressStart,
    this.showIcon = true,
    this.borderRadius = 24,
    super.key,
  });

  final String name;
  final String role;
  final String email;
  final String admin;
  final String? code;
  final String? phone;
  final Color? borderColor;
  final VoidCallback onTap;
  final Function(LongPressStartDetails)? onLongPressStart;
  final bool showIcon;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPressStart: onLongPressStart,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: borderColor,
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (code != null)
                  Row(
                    children: [
                      Text(
                        'MSGV: ',
                        style: StyleThemeData.styleSize14Weight500(),
                      ),
                      Text(
                        code ?? '',
                        style: StyleThemeData.styleSize14Weight700(),
                      ),
                    ],
                  ),
                if (code != null) const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Tên tài khoản: ',
                      style: StyleThemeData.styleSize14Weight500(),
                    ),
                    Text(
                      name,
                      style: StyleThemeData.styleSize14Weight700(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Vai trò: ',
                      style: StyleThemeData.styleSize14Weight500(),
                    ),
                    Text(
                      role,
                      style: StyleThemeData.styleSize14Weight700(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Email: ',
                      style: StyleThemeData.styleSize14Weight500(),
                    ),
                    Text(
                      email,
                      style: StyleThemeData.styleSize14Weight700(),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (phone != null)
                  Row(
                    children: [
                      Text(
                        'Số điện thoại: ',
                        style: StyleThemeData.styleSize14Weight500(),
                      ),
                      Text(
                        phone!,
                        style: StyleThemeData.styleSize14Weight700(),
                      ),
                    ],
                  ),
                if (phone != null) const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Người phân quyền: ',
                      style: StyleThemeData.styleSize14Weight500(),
                    ),
                    Text(
                      admin,
                      style: StyleThemeData.styleSize14Weight700(),
                    ),
                  ],
                ),
              ],
            ),
            if (showIcon) const Spacer(),
            if (showIcon) Icon(Icons.arrow_forward_ios, color: appTheme.appColor),
          ],
        ),
      ),
    );
  }
}
