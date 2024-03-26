import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/home/home_controller.dart';
import 'package:school_web/web/style/style_theme.dart';

class ChartTeacherView extends StatelessWidget {
  const ChartTeacherView({required this.homeController, super.key});
  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Obx(
          () => Container(
            padding: const EdgeInsets.all(16),
            width: 200,
            height: 225,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 5,
                borderData: FlBorderData(show: false),
                sectionsSpace: 2,
                sections: [
                  PieChartSectionData(
                    value: homeController.totalTeacher.toDouble(),
                    color: appTheme.appColor,
                    radius: 100,
                  ),
                  PieChartSectionData(
                    value: homeController.totalWorkingTeachers.toDouble(),
                    color: appTheme.successColor,
                    radius: 100,
                  ),
                  PieChartSectionData(
                    value: homeController.totalRetiredTeachers.toDouble(),
                    color: appTheme.yellow500Color,
                    radius: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appTheme.appColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Tổng số giáo viên',
                    style: StyleThemeData.styleSize14Weight400(height: 0),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appTheme.successColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Giáo viên đang làm',
                    style: StyleThemeData.styleSize14Weight400(height: 0),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: appTheme.yellow500Color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Giáo viên nghỉ làm',
                    style: StyleThemeData.styleSize14Weight400(height: 0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
