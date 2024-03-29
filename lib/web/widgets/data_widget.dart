import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/utils/assets/images.dart';

class DataWidget extends StatelessWidget {
  const DataWidget({
    required this.name,
    required this.code,
    required this.codeData,
    required this.phone,
    this.status,
    this.statusData,
    this.onTap,
    this.imageUrl,
    this.colorPhone,
    this.show = true,
    this.color,
    this.statusColor,
    this.showPhone = true,
    this.showDivider = true,
    super.key,
  });

  final String? imageUrl;
  final String name;
  final String code;
  final String? status;
  final String? statusData;
  final String codeData;
  final String phone;
  final Color? colorPhone;
  final VoidCallback? onTap;
  final bool show;
  final Color? color;
  final Color? statusColor;
  final bool showPhone;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    // final ValueNotifier<bool> _isInfoVisible = ValueNotifier<bool>(false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: CachedNetworkImage(
                  imageUrl: imageUrl.toString(),
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return Image.asset(ImagesAssets.noUrlImage, fit: BoxFit.cover);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: StyleThemeData.styleSize14Weight700(),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '$code: ',
                        style: StyleThemeData.styleSize14Weight500(),
                      ),
                      Text(
                        codeData,
                        style: StyleThemeData.styleSize14Weight400(color: appTheme.appColor),
                      ),
                    ],
                  ),
                  if (statusData != null) const SizedBox(height: 4),
                  if (statusData != null)
                    Row(
                      children: [
                        Text(
                          '$status: ',
                          style: StyleThemeData.styleSize14Weight500(color: appTheme.textDesColor),
                        ),
                        Text(
                          statusData!,
                          style: StyleThemeData.styleSize14Weight400(color: statusColor ?? appTheme.appColor),
                        ),
                      ],
                    ),
                  if (showPhone) const SizedBox(height: 4),
                  if (showPhone)
                    Row(
                      children: [
                        Text(
                          'Số điện thoại: ',
                          style: StyleThemeData.styleSize14Weight500(color: appTheme.textDesColor),
                        ),
                        Text(
                          (phone.length > 15) ? '${phone.substring(0, 15)}...' : phone,
                          style: StyleThemeData.styleSize14Weight400(color: colorPhone ?? appTheme.appColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                ],
              ),
              const Spacer(),
              SvgPicture.asset(IconAssets.caretRightIcon, width: 24, height: 24, color: color ?? appTheme.appColor),
            ],
          ),
        ),
        // if (show) SizedBox(height: 12.h),
        // if (show)
        //   ValueListenableBuilder<bool>(
        //     valueListenable: _isInfoVisible,
        //     builder: (context, isInfoVisible, child) {
        //       return InkWell(
        //         onTap: () {
        //           _isInfoVisible.value = !isInfoVisible;
        //         },
        //         child: Row(
        //           children: [
        //             Text(
        //               'Thông tin học sinh',
        //               style: StyleThemeData.styleSize14Weight400(
        //                 color: _isInfoVisible.value ? appTheme.blackColor : appTheme.textDesColor,
        //               ),
        //             ),
        //             const Spacer(),
        //             _isInfoVisible.value
        //                 ? Icon(
        //                     Icons.keyboard_arrow_up,
        //                     color: _isInfoVisible.value ? appTheme.textDesColor : appTheme.blackColor,
        //                   )
        //                 : Icon(Icons.keyboard_arrow_down, color: appTheme.textDesColor),
        //           ],
        //         ),
        //       );
        //     },
        //   ),
        // if (show) SizedBox(height: 12.h),
        // if (show)
        //   ValueListenableBuilder<bool>(
        //     valueListenable: _isInfoVisible,
        //     builder: (context, isInfoVisible, child) {
        //       return Visibility(
        //         visible: isInfoVisible,
        //         child: const Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             // Text('data'),
        //           ],
        //         ),
        //       );
        //     },
        //   ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 0, color: appTheme.strokeColor),
          ),
      ],
    );
  }
}
