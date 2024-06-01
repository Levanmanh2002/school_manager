import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/utils/assets/images.dart';
import 'package:url_launcher/url_launcher.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  String getGreeting() {
    var now = DateTime.now();
    var hour = now.hour;

    if (hour < 12) {
      return 'Chào buổi sáng';
    } else if (hour < 18) {
      return 'Chào buổi chiều';
    } else {
      return 'Chào buổi tối';
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    return Row(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Trang chủ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.5, color: Colors.black),
              ),
              const SizedBox(height: 4),
              Obx(
                () => Text(
                  '${getGreeting()},  ${authController.teacherData.value?.fullName ?? 'EDU Management'}! ',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Color(0xFF7E8695),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () async {
            await launchUrl(
              Uri.parse('https://drive.google.com/file/d/1wPiAOidlUWKlNHzCL-T7G-OGZ6II5pWo/view?usp=sharing'),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: appTheme.appColor,
            ),
            child: Row(
              children: [
                Image.asset(ImagesAssets.adminImage, width: 24),
                const SizedBox(width: 8),
                Text(
                  'Tải app EDU',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: appTheme.whiteColor),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
