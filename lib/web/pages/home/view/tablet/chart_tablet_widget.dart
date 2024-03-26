import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/home/home_controller.dart';
import 'package:school_web/web/pages/home/view/chart/chart_teacher_view.dart';
import 'package:school_web/web/pages/home/view/widget/chart_widget.dart';
import 'package:school_web/web/pages/home/view/widget/item_note_widget.dart';

class ChartTabletView extends StatefulWidget {
  const ChartTabletView({super.key});

  @override
  State<ChartTabletView> createState() => _ChartTabletViewState();
}

class _ChartTabletViewState extends State<ChartTabletView> with TickerProviderStateMixin {
  final HomeController homeController = Get.put(HomeController());

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> noteData = [
      {'borderColor': appTheme.appColor, 'title': 'Học sinh mới'},
      {'borderColor': appTheme.successColor, 'title': 'Đang học'},
      {'borderColor': appTheme.yellow500Color, 'title': 'Nghỉ học'},
      {'borderColor': appTheme.neutral40Color, 'title': 'Đình chỉ'},
      {'borderColor': appTheme.errorColor, 'title': 'Bị đuổi học'},
    ];

    List<double> dataChart = [
      homeController.totalNewStudent.toDouble(),
      homeController.activeStudents.toDouble(),
      homeController.selfSuspendedStudents.toDouble(),
      homeController.suspendedStudents.toDouble(),
      homeController.expelledStudents.toDouble(),
    ];

    updateBarGroups(dataChart);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFFFFFFF),
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
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(right: 12, top: 16),
                    child: Text(
                      'Biểu đồ trạng thái học sinh',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF373743)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    labelColor: const Color(0xFF3A73C2),
                    unselectedLabelColor: const Color(0xFF7E8695),
                    indicatorColor: const Color(0xFF3A73C2),
                    indicatorWeight: 1,
                    tabs: const [
                      Tab(text: 'Học sinh'),
                      Tab(text: 'Giáo viên'),
                    ],
                  ),
                ),
                Container(
                  constraints: const BoxConstraints(maxHeight: 432),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 16),
                              width: double.maxFinite,
                              height: 325,
                              child: AspectRatio(
                                aspectRatio: 1.6,
                                child: BarChart(
                                  BarChartData(
                                    barTouchData: barTouchData,
                                    titlesData: titlesData,
                                    borderData: borderData,
                                    barGroups: barGroups,
                                    gridData: const FlGridData(show: true),
                                    alignment: BarChartAlignment.spaceAround,
                                    maxY: 1000,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (int index = 0; index < noteData.length; index++)
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: itemNoteWidget(
                                              borderColor: noteData[index]['borderColor'],
                                              title: noteData[index]['title'],
                                            ),
                                          ),
                                          const SizedBox(width: 24),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ChartTeacherView(homeController: homeController),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
