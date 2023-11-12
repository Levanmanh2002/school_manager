import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/home/controller/chart_controller.dart';
import 'package:school_web/web/pages/home/view/chart.dart';
import 'package:school_web/web/pages/home/widgets/storage_info_card_data_widget.dart';

class ExpandedFlex2View extends StatelessWidget {
  const ExpandedFlex2View({
    super.key,
    required this.controller,
  });

  final ChartController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: Responsive.isMobile(context)
          ? 4
          : Responsive.isTablet(context)
              ? 4
              : 2,
      child: Container(
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Biểu đồ học sinh',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    height: 200,
                    child: Stack(
                      children: [
                        const PieChartSection(),
                        Positioned.fill(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Tổng',
                                style: TextStyle(
                                  fontSize: Responsive.isMobile(context)
                                      ? 12
                                      : Responsive.isTablet(context)
                                          ? 12
                                          : 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${controller.numberOfActiveStudents.value.toDouble() + controller.numberOfInactiveStudents.value.toDouble() + controller.numberOfSuspendedStudents.value.toDouble() + controller.numberOfExpelledStudents.value.toDouble()}',
                                style: TextStyle(
                                  fontSize: Responsive.isMobile(context)
                                      ? 10
                                      : Responsive.isTablet(context)
                                          ? 10
                                          : 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  StorageInfoCardData(
                    color: Colors.green,
                    title: Responsive.isMobile(context)
                        ? 'Học sinh đang học'
                        : Responsive.isTablet(context)
                            ? 'Học sinh đang học'
                            : 'Đang học',
                    text: '${controller.numberOfActiveStudents.value.toDouble()}',
                  ),
                  const SizedBox(height: 12),
                  StorageInfoCardData(
                    color: Colors.orange,
                    title: Responsive.isMobile(context)
                        ? 'Học sinh đã nghỉ học'
                        : Responsive.isTablet(context)
                            ? 'Học sinh đã nghỉ học'
                            : 'Nghỉ học',
                    text: '${controller.numberOfInactiveStudents.value.toDouble()}',
                  ),
                  const SizedBox(height: 12),
                  StorageInfoCardData(
                    color: Colors.blue,
                    title: Responsive.isMobile(context)
                        ? 'Học sinh đang bị đình chỉ'
                        : Responsive.isTablet(context)
                            ? 'Học sinh đang bị đình chỉ'
                            : 'Bị đình chỉ',
                    text: '${controller.numberOfSuspendedStudents.value.toDouble()}',
                  ),
                  const SizedBox(height: 12),
                  StorageInfoCardData(
                    color: Colors.red,
                    title: Responsive.isMobile(context)
                        ? 'Học sinh bị đuổi học'
                        : Responsive.isTablet(context)
                            ? 'Học sinh bị đuổi học'
                            : 'Bị đuổi học',
                    text: '${controller.numberOfExpelledStudents.value.toDouble()}',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
