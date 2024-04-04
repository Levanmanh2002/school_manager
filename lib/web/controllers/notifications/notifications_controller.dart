import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/models/notifications.dart';
import 'package:school_web/web/utils/status/status.dart';

class NotificationsController extends GetxController {
  RxList<Notifications> notifications = <Notifications>[].obs;

  var unreadCountNoti = 0.obs;

  int countUnreadNotifications() {
    return notifications.where((notification) => !notification.isRead!).length;
  }

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    unreadCount();
  }

  Future<void> fetchNotifications() async {
    try {
      const apiUrl = 'https://backend-shool-project.onrender.com/admin/notifications';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body)['notifications'];
        notifications.assignAll(data.map((json) => Notifications.fromJson(json)).toList());
      } else {
        print('Error fetching notifications. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching notifications: $error');
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      var request = http.Request(
        'DELETE',
        Uri.parse('https://backend-shool-project.onrender.com/admin/notifications/$id'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        notifications.removeWhere((element) => element.sId == id);

        showSuccessStatus('Xóa thông báo thành công');
      } else {
        showFailStatus('Xóa thất bại');
      }
    } catch (error) {
      print('Lỗi xóa notification: $error');
    }
  }

  Future<void> updateMarkAsRead(String id) async {
    try {
      var request = http.Request(
        'PUT',
        Uri.parse('https://backend-shool-project.onrender.com/admin/notifications/mark-as-read/$id'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final index = notifications.indexWhere((element) => element.sId == id);
        if (index != -1) {
          notifications[index].isRead = true;
        }
        unreadCount();
        notifications.refresh();
      } else {
        showFailStatus('Đánh dấu thất bại. Vui lòng thử lại sau');
      }
    } catch (error) {
      print('Lỗi update mark as read: $error');
    }
  }

  Future<void> updateMarkAllAsRead() async {
    try {
      var request = http.Request(
        'PUT',
        Uri.parse('https://backend-shool-project.onrender.com/admin/notifications/mark-all-as-read'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        for (var notification in notifications) {
          notification.isRead = true;
        }

        unreadCount();
        notifications.refresh();
      } else {
        showFailStatus('Đánh dấu thất bại. Vui lòng thử lại sau');
      }
    } catch (error) {
      print('Lỗi mark all as read: $error');
    }
  }

  Future<void> unreadCount() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/unread-count'));

      if (response.statusCode == 201) {
        final result = json.decode(response.body);

        unreadCountNoti.value = result['unreadCount'];
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Lỗi get data unread count:  $error');
    }
  }
}
