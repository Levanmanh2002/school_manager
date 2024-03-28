import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/auth_controller.dart';
import 'package:school_web/web/controllers/notifications/notifications_controller.dart';
import 'package:school_web/web/pages/dashboard/controller/side_bar_controller.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/widgets/box_shadow_widget.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class NotificationsDetails extends StatelessWidget {
  const NotificationsDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final SideBarController sideBarController = Get.put(SideBarController());
    final NotificationsController notificationsController = Get.put(NotificationsController());
    final AuthController authController = Get.put(AuthController());

    String formatDateTime(String dateTimeString) {
      DateTime dateTime = DateTime.parse(dateTimeString);

      String formattedDateTime = DateFormat('HH:mm dd/MM/yyyy').format(dateTime);

      return formattedDateTime;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: BoxShadowWidget(
        radius: 24,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Thông báo gần đây',
                        style: StyleThemeData.styleSize16Weight600(height: 0, color: appTheme.appColor),
                      ),
                    ),
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
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: appTheme.textDesColor),
                        ),
                        child: Text('Đánh dấu đã đọc tất cả', style: StyleThemeData.styleSize14Weight400(height: 0)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: appTheme.textDesColor, height: 0),
                ),
                ...notificationsController.notifications.map((notification) {
                  return ColoredBox(
                    color: (notification.isRead == false) ? appTheme.primary50Color : appTheme.whiteColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 12),
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
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                notificationsController.updateMarkAsRead(notification.sId.toString());
                                if (notification.teacherId != null) {
                                  // Navigator.pop(context);

                                  sideBarController.index.value = 1;
                                } else if (notification.studentId != null) {
                                  // Navigator.pop(context);

                                  sideBarController.index.value = 2;
                                } else if (notification.systemIds != null) {
                                  // Navigator.pop(context);

                                  // sideBarController.index.value = 7;
                                } else if (notification.classIds != null) {
                                  // Navigator.pop(context);

                                  sideBarController.index.value = 3;
                                } else if (notification.uniformIds != null) {
                                  // Navigator.pop(context);

                                  sideBarController.index.value = 6;
                                } else if (notification.feesIds != null) {
                                  // Navigator.pop(context);

                                  sideBarController.index.value = 5;
                                } else if (notification.majorIds != null) {
                                  // Navigator.pop(context);

                                  sideBarController.index.value = 4;
                                } else {
                                  // Navigator.pop(context);
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(notification.title ?? '', style: StyleThemeData.styleSize12Weight600()),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification.message ?? '',
                                    style: StyleThemeData.styleSize12Weight400(color: appTheme.textDesColor),
                                  ),
                                  Text(
                                    formatDateTime(notification.createdAt ?? ''),
                                    style: StyleThemeData.styleSize14Weight400(color: appTheme.strokeColor),
                                  ),
                                  // if (!isLastItem) SizedBox(height: 12.h),
                                ],
                              ),
                            ),
                          ),
                          PopupMenuButton(
                            position: PopupMenuPosition.under,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: SvgPicture.asset(IconAssets.dotsIcon),
                            ),
                            onSelected: (value) {
                              if (authController.teacherData.value?.system == 1 ||
                                  authController.teacherData.value?.system == 2) {
                                if (value == 1) {
                                  notificationsController.updateMarkAsRead(notification.sId.toString());
                                } else if (value == 2) {
                                  notificationsController.deleteNotification(notification.sId.toString());
                                }
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
                            itemBuilder: (context) => <PopupMenuEntry>[
                              PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      IconAssets.evaluateIcon,
                                      color: appTheme.blackColor,
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Đánh dấu đã đọc',
                                      style: StyleThemeData.styleSize12Weight500(height: 0),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      IconAssets.deleteIcon,
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Xóa thông báo',
                                      style: StyleThemeData.styleSize12Weight500(height: 0, color: appTheme.errorColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
