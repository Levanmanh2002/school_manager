import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/home/home_controller.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/home/view/overview_view.dart';
import 'package:school_web/web/pages/home/view/mobile/list_data_mobile_widget.dart';
import 'package:school_web/web/pages/home/view/tablet/chart_tablet_widget.dart';
import 'package:school_web/web/pages/home/view/tablet/list_data_tablet_widget.dart';
import 'package:school_web/web/pages/home/view/widget/app_bar_widget.dart';
import 'package:school_web/web/utils/assets/images.dart';
import 'package:url_launcher/url_launcher.dart';

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
      bottomNavigationBar: Container(
        height: 60,
        color: Colors.white,
        child: Row(
          children: [
            const SizedBox(width: 24),
            const Text(
              '© 2023 EDU Management',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.5,
                color: Color(0xFF7E8695),
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
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}
