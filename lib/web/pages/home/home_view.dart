import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/home/controller/chart_controller.dart';
import 'package:school_web/web/pages/home/view/expanded_flex1_view.dart';
import 'package:school_web/web/pages/home/view/expanded_flex2_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ChartController controller = Get.put(ChartController());
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    controller.fetchNumberActiveData();
    controller.fetchNumberInactiveData();
    controller.fetchNumberSuspendedData();
    controller.fetchNumberExpelledData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive.isMobile(context)
          ? Column(
              children: [
                const SizedBox(width: 16),
                ExpandedFlex2View(controller: controller),
                const SizedBox(width: 16),
                const ExpandedFlex1View(),
                const SizedBox(width: 16),
              ],
            )
          : Responsive.isTablet(context)
              ? Column(
                  children: [
                    const SizedBox(width: 16),
                    ExpandedFlex2View(controller: controller),
                    const SizedBox(width: 16),
                    const ExpandedFlex1View(),
                    const SizedBox(width: 16),
                  ],
                )
              : Row(
                  children: [
                    const SizedBox(width: 16),
                    const ExpandedFlex1View(),
                    const SizedBox(width: 16),
                    ExpandedFlex2View(controller: controller),
                    const SizedBox(width: 16),
                  ],
                ),
    );
  }
}
