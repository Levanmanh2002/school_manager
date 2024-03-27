import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthenticationController authController = Get.put(AuthenticationController());

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
                  'Chào buổi sáng, ${authController.teacherData.value?.fullName ?? 'EDU Management'}! ',
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
        // const Spacer(),
        // InkWell(
        //   onTap: () => authController.teacherData.value?.system == 1 || authController.teacherData.value?.system == 2
        //       ? Get.toNamed(Routes.CREATE)
        //       : showNoSystemWidget(
        //           context,
        //           title: 'Bạn không có quyền thêm lịch học',
        //           des: 'Rất tiếc, bạn không có quyền thêm lịch học. Vui lòng liên hệ với người quản trị để được hỗ trợ',
        //           cancel: 'Hủy',
        //           confirm: 'Xác nhận',
        //           ontap: () => Navigator.pop(context),
        //         ),
        //   child: Container(
        //     padding: const EdgeInsets.all(12),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(12),
        //       color: const Color(0xFF3A73C2),
        //     ),
        //     child: Row(
        //       children: [
        //         SvgPicture.asset('assets/icons/timetable.svg'),
        //         const SizedBox(width: 8),
        //         const Text(
        //           'Thêm lịch học',
        //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFFFFFFFF)),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        const SizedBox(width: 16),
      ],
    );
  }
}
