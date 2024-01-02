import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/models/notifications.dart';

class NotificationsController extends GetxController {
  RxList<Notifications> notifications = <Notifications>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
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
}
