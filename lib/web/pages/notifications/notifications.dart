import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_web/web/controllers/notifications/notifications_controller.dart';
import 'package:school_web/web/utils/assets/icons.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
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
        maxWidth: MediaQuery.of(context).size.width,
      ),
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem(
            enabled: false,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Thông báo gần đây',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3A73C2),
                      ),
                    ),
                    SizedBox(width: 60),
                    Text(
                      'Đánh dấu đã đọc tất cả',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3A73C2),
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
          ...notificationsController.notifications.take(5).map((notification) {
            return PopupMenuItem(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        notification.teacherId?.avatarUrl ??
                            'https://firebasestorage.googleapis.com/v0/b/school-manager-d9566.appspot.com/o/admin.png?alt=media&token=1d3acd26-4c07-4fb8-b0b4-a5e88d75a512',
                      ),
                      radius: 25,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Thông báo!',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatDateTime(notification.createdAt ?? ''),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          PopupMenuItem(
            enabled: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Xem thêm',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3A73C2),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF3A73C2)),
                ],
              ),
            ),
          ),
        ];
      },
      child: Obx(
        () => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF7F7FC),
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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF3A73C2),
                  ),
                  child: Text(
                    notificationsController.notifications.length.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
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
