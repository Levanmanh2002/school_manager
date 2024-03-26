import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/web/controllers/home/home_controller.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/utils/assets/images.dart';

class OverviewView extends StatelessWidget {
  const OverviewView({required this.homeController, super.key});

  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return Obx(
        () => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: itemCartDashboard(
                    context,
                    image: ImagesAssets.studentImage,
                    data: homeController.totalAll.toString(),
                    text: 'Tổng số học sinh',
                  ),
                ),
                Expanded(
                  child: _buildItem(
                    context,
                    ImagesAssets.studentImage,
                    'Học sinh mới',
                    homeController.totalNewStudent.toString(),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildItem(
                    context,
                    ImagesAssets.teachImage,
                    'Giáo viên',
                    homeController.totalTeacher.toString(),
                  ),
                ),
                Expanded(
                  child: _buildItem(
                    context,
                    ImagesAssets.bookImage,
                    'Lớp học',
                    homeController.totalClass.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Obx(
        () => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: itemCartCirle(
                context,
                image: ImagesAssets.studentImage,
                data: homeController.totalAll.toString(),
                text: 'Tổng số học sinh',
              ),
            ),
            Expanded(
              child: _buildItemCirle(
                context,
                ImagesAssets.studentImage,
                'Học sinh mới',
                homeController.totalNewStudent.toString(),
              ),
            ),
            Expanded(
              child: _buildItemCirle(
                context,
                ImagesAssets.teachImage,
                'Tất cả giáo viên',
                homeController.totalTeacher.toString(),
              ),
            ),
            Expanded(
              child: _buildItemCirle(
                context,
                ImagesAssets.bookImage,
                'Lớp học',
                homeController.totalClass.toString(),
              ),
            ),
          ],
        ),
      );
    }
  }
}

Widget _buildItem<T>(BuildContext context, String image, String text, String data) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x143A73C2),
            blurRadius: 8.0,
            offset: Offset(0, 0),
          ),
          BoxShadow(
            color: Color(0x143A73C2),
            blurRadius: 8.0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.only(top: 12, bottom: 0, left: 16, right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFECFAFD),
            ),
            child: Image.asset(image, width: 66, height: 66),
          ),
          Column(
            children: [
              Text(
                data,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.5, color: Colors.black),
              ),
              const SizedBox(height: 4),
            ],
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5, color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

Widget _buildItemCirle<T>(BuildContext context, String image, String text, String data) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x143A73C2),
            blurRadius: 8.0,
            offset: Offset(0, 0),
          ),
          BoxShadow(
            color: Color(0x143A73C2),
            blurRadius: 8.0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    color: Color(0xFF124C72),
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Color(0xFF373743),
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFECFAFD),
            ),
            child: Image.asset(image, width: 41, height: 41),
          ),
        ],
      ),
    ),
  );
}

Widget itemCartDashboard(BuildContext context, {required String image, required String data, required String text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x143A73C2),
            blurRadius: 8.0,
            offset: Offset(0, 0),
          ),
          BoxShadow(
            color: Color(0x143A73C2),
            blurRadius: 8.0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.only(top: 12, bottom: 0, left: 16, right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFECFAFD),
            ),
            child: Image.asset(image, width: 66, height: 66),
          ),
          Text(
            data,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.5, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5, color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

Widget itemCartCirle(BuildContext context, {required String image, required String data, required String text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x143A73C2),
            blurRadius: 8.0,
            offset: Offset(0, 0),
          ),
          BoxShadow(
            color: Color(0x143A73C2),
            blurRadius: 8.0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    color: Color(0xFF124C72),
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Color(0xFF373743),
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFECFAFD),
            ),
            child: Image.asset(image, width: 41, height: 41),
          ),
        ],
      ),
    ),
  );
}
