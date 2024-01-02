import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  final NotificationsController notificationsController = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Obx(() {
        if (notificationsController.notifications.isEmpty) {
          return const Center(child: Text('No notifications available.'));
        } else {
          return ListView.builder(
            itemCount: notificationsController.notifications.length,
            itemBuilder: (context, index) {
              final notification = notificationsController.notifications[index];
              return ListTile(
                title: Text(notification.message ?? ''),
                subtitle: Text('Teacher ID: ${notification.teacherId?.sId ?? ''}'),
                // Hiển thị thông tin chi tiết tùy thuộc vào yêu cầu của bạn
                // Ví dụ:
                // subtitle: Text('Name: ${notification.teacherId?.teacherData?.fullName ?? ''}'),
              );
            },
          );
        }
      }),
    );
  }
}
