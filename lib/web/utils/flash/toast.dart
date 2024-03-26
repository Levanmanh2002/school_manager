import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/utils/flash/flash.dart';

// void showToast(
//   String title,
//   String content, {
//   bool? isWarningToast = false,
//   Color? color,
//   String? imagePath,
//   Widget? iconWidget,
//   bool isTopPosition = true,
//   Function()? onTap,
// }) {
//   showFlash(
//     context: Get.context!,
//     duration: const Duration(seconds: 3),
//     // persistent: false,
//     builder: (_, controller) {
//       return Flash(
//         borderRadius: Component.radius.radius8,
//         margin: padding(all: 24),
//         controller: controller,
//         backgroundColor: Colors.white,
//         boxShadows: Component.shadow.toastShadow,
//         barrierDismissible: true,
//         behavior: FlashBehavior.floating,
//         position: isTopPosition ? FlashPosition.top : FlashPosition.bottom,
//         onTap: () async {
//           await controller.dismiss();
//           if (onTap != null) {
//             onTap()!;
//           }
//         },
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: padding(horizontal: 8, vertical: 12),
//               child: IntrinsicHeight(
//                 child: Row(
//                   children: [
//                     Container(
//                       width: width(3),
//                       decoration: BoxDecoration(
//                         borderRadius: Component.radius.customRadius(18),
//                         color:
//                             color ?? (isWarningToast! ? Component.color.secondaryColor : Component.color.successColor),
//                       ),
//                     ),
//                     SizedBox(
//                       width: width(12),
//                     ),
//                     iconWidget ??
//                         SvgImageCustom(
//                             imagePath: imagePath ?? (isWarningToast! ? ImagePaths.warning : ImagePaths.success),
//                             size: 32),
//                     SizedBox(width: width(9)),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             title,
//                             style: Component.textStyle.mediumSemiBold,
//                             // ? Fix Issue SFA-1137
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(
//                             content,
//                             style: Component.textStyle.smallMedium.copyWith(color: Component.color.grey400),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       width: width(8),
//                     ),
//                     GestureDetector(
//                       onTap: controller.dismiss,
//                       child: SvgImageCustom(
//                         imagePath: ImagePaths.close,
//                         size: 16,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

// void showNotifyToast({required String title, required String content, required Function onTap}) {
//   showFlash(
//     context: Get.context!,
//     duration: const Duration(seconds: 3),
//     builder: (_, controller) {
//       return Flash(
//         borderRadius: Component.radius.radius8,
//         margin: padding(horizontal: 16, vertical: 12),
//         controller: controller,
//         backgroundColor: Colors.white,
//         boxShadows: Component.shadow.toastShadow,
//         barrierDismissible: true,
//         behavior: FlashBehavior.floating,
//         position: FlashPosition.top,
//         onTap: () => {
//           controller.dismiss(),
//           onTap(),
//         },
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: padding(horizontal: 8, vertical: 12),
//               child: IntrinsicHeight(
//                 child: Row(
//                   children: [
//                     Container(
//                       width: width(3),
//                       decoration: BoxDecoration(
//                         borderRadius: Component.radius.customRadius(18),
//                         color: Component.color.primaryColor,
//                       ),
//                     ),
//                     SizedBox(
//                       width: width(12),
//                     ),
//                     Container(
//                       height: width(24),
//                       width: width(24),
//                       decoration: BoxDecoration(
//                         borderRadius: Component.radius.radius100,
//                         color: Component.color.primaryColor,
//                       ),
//                       child: Center(
//                         child: SvgImageCustom(imagePath: ImagePaths.product_dashboard, size: 14),
//                       ),
//                     ),
//                     SizedBox(width: width(9)),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             title,
//                             style: Component.textStyle.xsSmallBold,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           Text(
//                             content,
//                             style: Component.textStyle.exSmallRegular.copyWith(color: Component.color.grey400),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(width: width(8)),
//                     GestureDetector(
//                       onTap: controller.dismiss,
//                       child: SvgImageCustom(
//                         imagePath: ImagePaths.close_toast,
//                         size: 16,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }

void showSimpleToast(String content, {double? borderRadius}) {
  showFlash(
    context: navigatorKey.currentContext!,
    duration: const Duration(seconds: 2),
    builder: (_, controller) {
      return Flash<void>(
        borderRadius: BorderRadius.circular(borderRadius ?? 1000),
        margin: const EdgeInsets.all(24),
        controller: controller,
        backgroundColor: const Color(0x80000000).withOpacity(0.7),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(2, 2),
            blurRadius: 1000,
          ),
        ],
        behavior: FlashBehavior.floating,
        position: FlashPosition.bottom,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            content,
            textAlign: TextAlign.center,
            style: StyleThemeData.styleSize14Weight500(color: appTheme.whiteColor, height: 0),
          ),
        ),
      );
    },
  );
}

void showSimpleIconsToast(String content, {String? icons}) {
  showFlash(
    context: navigatorKey.currentContext!,
    duration: const Duration(seconds: 2),
    builder: (_, controller) {
      return Flash<void>(
        borderRadius: BorderRadius.circular(8),
        margin: const EdgeInsets.all(24),
        controller: controller,
        backgroundColor: appTheme.red10Color,
        borderColor: appTheme.errorColor,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: const Offset(10, 10),
            blurRadius: 100,
          ),
        ],
        behavior: FlashBehavior.floating,
        position: FlashPosition.bottom,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              SvgPicture.asset(icons ?? IconAssets.errorCircleIcon, width: 24, height: 24),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  content,
                  textAlign: TextAlign.left,
                  style: StyleThemeData.styleSize14Weight500(color: appTheme.errorColor, height: 0),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
