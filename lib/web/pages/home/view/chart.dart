import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/web/pages/home/controller/chart_controller.dart';

class PieChartSection extends StatelessWidget {
  const PieChartSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ChartController controller = Get.put(ChartController());

    return Obx(
      () => PieChart(
        PieChartData(
          sectionsSpace: 0,
          startDegreeOffset: -90,
          sections: [
            PieChartSectionData(
              value: controller.numberOfActiveStudents.value.toDouble(),
              color: Colors.green,
              radius: 25,
              showTitle: false,
              titleStyle: const TextStyle(color: Colors.white),
            ),
            PieChartSectionData(
              value: controller.numberOfInactiveStudents.value.toDouble(),
              color: Colors.orange,
              radius: 23,
              showTitle: false,
              titleStyle: const TextStyle(color: Colors.white),
            ),
            PieChartSectionData(
              value: controller.numberOfSuspendedStudents.value.toDouble(),
              color: Colors.blue,
              radius: 21,
              showTitle: false,
              titleStyle: const TextStyle(color: Colors.white),
            ),
            PieChartSectionData(
              value: controller.numberOfExpelledStudents.value.toDouble(),
              color: Colors.red,
              radius: 19,
              showTitle: false,
              titleStyle: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
