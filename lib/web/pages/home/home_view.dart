import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/web/controllers/home/home_controller.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/home/view/overview_view.dart';
import 'package:school_web/web/pages/home/view/mobile/list_data_mobile_widget.dart';
import 'package:school_web/web/pages/home/view/tablet/chart_tablet_widget.dart';
import 'package:school_web/web/pages/home/view/tablet/list_data_tablet_widget.dart';
import 'package:school_web/web/pages/home/view/widget/app_bar_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());

    return Scaffold(
      body: Responsive.isMobile(context)
          ? SingleChildScrollView(
              child: Column(
                children: [
                  OverviewView(homeController: homeController),
                  const SizedBox(height: 24),
                  const ChartTabletView(),
                  const SizedBox(height: 24),
                  const ListDataMobileWidget(),
                  const SizedBox(height: 24),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const AppBarWidget(),
                    OverviewView(homeController: homeController),
                    const SizedBox(width: 24),
                    const ChartTabletView(),
                    const SizedBox(height: 24),
                    const ListDataTabletWidget(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}
