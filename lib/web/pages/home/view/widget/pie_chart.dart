import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/web/controllers/home/home_controller.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    if (Responsive.isMobile(context)) {
      return ItemPieColumnChart(
        teacherData: homeController.totalTeacher.toDouble(),
        workingTeachers: homeController.totalWorkingTeachers.toDouble(),
        retiredTeachers: homeController.totalRetiredTeachers.toDouble(),
      );
    } else {
      return ItemPieRowChart(
        teacherData: homeController.totalTeacher.toDouble(),
        workingTeachers: homeController.totalWorkingTeachers.toDouble(),
        retiredTeachers: homeController.totalRetiredTeachers.toDouble(),
      );
    }
  }
}

class ItemPieRowChart extends StatelessWidget {
  const ItemPieRowChart({
    super.key,
    required this.teacherData,
    required this.workingTeachers,
    required this.retiredTeachers,
  });

  final double? teacherData;
  final double? workingTeachers;
  final double? retiredTeachers;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          width: 200,
          height: 325,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 5,
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              sections: [
                PieChartSectionData(
                  value: teacherData,
                  color: const Color(0xFF2D9CDB),
                  radius: 100,
                ),
                PieChartSectionData(
                  value: workingTeachers,
                  color: const Color(0xFF3BB53B),
                  radius: 100,
                ),
                PieChartSectionData(
                  value: retiredTeachers,
                  color: const Color(0xFFFC8805),
                  radius: 100,
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF2D9CDB),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Tổng số giáo viên',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF2D9CDB)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF3BB53B),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Đang làm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF3BB53B)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFC8805),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Nghỉ làm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFFFC8805)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ItemPieColumnChart extends StatelessWidget {
  const ItemPieColumnChart({
    super.key,
    required this.teacherData,
    required this.workingTeachers,
    required this.retiredTeachers,
  });

  final double? teacherData;
  final double? workingTeachers;
  final double? retiredTeachers;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          width: 200,
          height: 325,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 5,
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              sections: [
                PieChartSectionData(
                  value: teacherData,
                  color: const Color(0xFF2D9CDB),
                  radius: 100,
                ),
                PieChartSectionData(
                  value: workingTeachers,
                  color: const Color(0xFF3BB53B),
                  radius: 100,
                ),
                PieChartSectionData(
                  value: retiredTeachers,
                  color: const Color(0xFFFC8805),
                  radius: 100,
                ),
              ],
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF2D9CDB),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Tổng số giáo viên',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF2D9CDB)),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF3BB53B),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Đang làm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF3BB53B)),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFC8805),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Nghỉ làm',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFFFC8805)),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
