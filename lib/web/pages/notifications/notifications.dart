import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/auth_controller.dart';
import 'package:school_web/web/controllers/notifications/notifications_controller.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/dashboard/controller/side_bar_controller.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({required this.sideBarController, super.key});
  final SideBarController sideBarController;

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    final NotificationsController notificationsController = Get.put(NotificationsController());

    String formatDateTime(String dateTimeString) {
      DateTime dateTime = DateTime.parse(dateTimeString);

      String formattedDateTime = DateFormat('HH:mm dd/MM/yyyy').format(dateTime);

      return formattedDateTime;
    }

    return PopupMenuButton(
      position: PopupMenuPosition.under,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {},
      constraints: BoxConstraints(
        minWidth: 2.0 * 48.0,
        maxWidth:
            Responsive.isMobile(context) ? MediaQuery.of(context).size.width / 1.5 : MediaQuery.of(context).size.width,
      ),
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem(
            enabled: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thông báo gần đây',
                      style: StyleThemeData.styleSize16Weight500(color: appTheme.appColor),
                    ),
                    const SizedBox(width: 60),
                    InkWell(
                      onTap: () {
                        if (authController.teacherData.value?.system == 1 ||
                            authController.teacherData.value?.system == 2) {
                          notificationsController.updateMarkAllAsRead();
                        } else {
                          showNoSystemWidget(
                            context,
                            title: 'Bạn không có quyền',
                            des: 'Xin lỗi, bạn không có quyền truy cập chức năng của giáo viên.',
                            cancel: 'Hủy',
                            confirm: 'Xác nhận',
                            ontap: () => Navigator.pop(context),
                          );
                        }
                      },
                      child: Responsive.isMobile(context)
                          ? SvgPicture.asset(IconAssets.listChecksIcon, width: 24, height: 24)
                          : Text(
                              'Đánh dấu đã đọc tất cả',
                              style: StyleThemeData.styleSize16Weight500(color: appTheme.appColor),
                            ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
          ...notificationsController.notifications.map((notification) {
            return PopupMenuItem(
              child: InkWell(
                onTap: () {
                  if (notification.teacherId != null) {
                    Navigator.pop(context);

                    sideBarController.index.value = 1;
                  } else if (notification.studentId != null) {
                    Navigator.pop(context);

                    sideBarController.index.value = 2;
                  } else if (notification.systemIds != null) {
                    Navigator.pop(context);

                    // sideBarController.index.value = 7;
                  } else if (notification.classIds != null) {
                    Navigator.pop(context);

                    sideBarController.index.value = 3;
                  } else if (notification.uniformIds != null) {
                    Navigator.pop(context);

                    sideBarController.index.value = 6;
                  } else if (notification.feesIds != null) {
                    Navigator.pop(context);

                    sideBarController.index.value = 5;
                  } else if (notification.majorIds != null) {
                    Navigator.pop(context);

                    sideBarController.index.value = 4;
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(1000),
                        child: SvgPicture.asset(
                          (notification.studentId != null)
                              ? IconAssets.notiStudentIcon
                              : (notification.teacherId != null)
                                  ? IconAssets.notiTeacherIcon
                                  : (notification.classIds != null)
                                      ? IconAssets.notiClassIcon
                                      : (notification.feesIds != null)
                                          ? IconAssets.notiFeesIcon
                                          : (notification.uniformIds != null)
                                              ? IconAssets.notiFeesIcon
                                              : IconAssets.notiIcon,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notification.title ?? '', style: StyleThemeData.styleSize16Weight600()),
                          const SizedBox(height: 4),
                          Container(
                            constraints: BoxConstraints(maxWidth: Responsive.isMobile(context) ? 220 : double.infinity),
                            child: Text(
                              notification.message ?? '',
                              style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            formatDateTime(notification.createdAt ?? ''),
                            style: StyleThemeData.styleSize14Weight400(color: appTheme.strokeColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ];
      },
      child: Obx(
        () => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appTheme.background700Color,
                ),
                child: SvgPicture.asset(IconAssets.bellSimpleIcon),
              ),
            ),
            Positioned(
              top: 0,
              right: 4,
              child: InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appTheme.appColor,
                  ),
                  child: Text(
                    notificationsController.notifications.length.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: appTheme.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
