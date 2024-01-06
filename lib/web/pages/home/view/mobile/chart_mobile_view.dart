import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/pages/home/view/widget/chart_widget.dart';
import 'package:school_web/web/pages/home/view/widget/item_note_widget.dart';
import 'package:school_web/web/pages/home/view/widget/pie_chart.dart';

class ChartMobileView extends StatefulWidget {
  const ChartMobileView({super.key});

  @override
  State<ChartMobileView> createState() => _ChartMobileViewState();
}

class _ChartMobileViewState extends State<ChartMobileView> with TickerProviderStateMixin {
  late DateTime currentWeek = DateTime.now();
  var isLoadingChart = false;

  late DateTime selectedStartTimeDate = DateTime.now();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    getCountNewStudents();
    getTimeData();
    _tabController = TabController(length: 2, vsync: this);
  }

  String? timeData;

  List<List<Map<String, dynamic>>> studentsList = [];

  Future<void> _selectStartTimeDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartTimeDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        selectedStartTimeDate = picked;
        const FlutterSecureStorage().write(
          key: "timeData",
          value: selectedStartTimeDate.millisecondsSinceEpoch.toString(),
        );
      });

      getCountNewStudents();
    }
  }

  Future<void> getCountNewStudents() async {
    final timeData = await const FlutterSecureStorage().read(key: 'timeData');

    var response = await http.get(
      Uri.parse(
        'https://backend-shool-project.onrender.com/chart/countNewStudentInWeek?startDate=${timeData ?? selectedStartTimeDate.millisecondsSinceEpoch}',
      ),
    );

    if (response.statusCode == 201) {
      var jsonData = json.decode(response.body);
      List<dynamic> data = jsonData['data'];

      List<double> toYValues = data.map((item) => (item['nunber'] as num).toDouble()).toList();

      updateBarGroups(toYValues);
      studentsList.clear();

      for (var timetableData in data) {
        if (timetableData['student'] != null) {
          var studentDataList = (timetableData['student'] as List<dynamic>).cast<Map<String, dynamic>>().toList();
          studentsList.add(studentDataList);
        }
      }
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> getTimeData() async {
    var timeData = await const FlutterSecureStorage().read(key: 'timeData');
    setState(() {
      timeData = timeData;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> noteData = [
      {'borderColor': const Color(0xFF3A73C2), 'title': 'Học sinh mới'},
      {'borderColor': const Color(0xFF3BB53B), 'title': 'Đang học'},
      {'borderColor': const Color(0xFFFC8805), 'title': 'Nghỉ học'},
      {'borderColor': const Color(0xFF9AA0AC), 'title': 'Đình chỉ'},
      {'borderColor': const Color(0xFFF94144), 'title': 'Bị đuổi học'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Text(
                  'Biểu đồ trạng thái học sinh',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF373743)),
                ),
              ),
              FittedBox(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: InkWell(
                      onTap: () async {
                        await _selectStartTimeDate(context);
                        getCountNewStudents();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF7E8695)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              timeData != null
                                  ? DateFormat('dd/MM/yyyy')
                                      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timeData ?? '')))
                                  : DateFormat('dd/MM/yyyy').format(selectedStartTimeDate),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF7E8695),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SvgPicture.asset('assets/icons/caret_down.svg'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
                Container(
                  padding: const EdgeInsets.only(top: 12),
                  constraints: const BoxConstraints.expand(height: 37),
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
                  constraints: const BoxConstraints(maxHeight: 452),
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
                            Wrap(
                              spacing: 14,
                              runSpacing: 12,
                              children: [
                                ...List.generate(
                                  noteData.length,
                                  (index) => SizedBox(
                                    width: 100,
                                    child: itemNoteWidget(
                                      borderColor: noteData[index]['borderColor'],
                                      title: noteData[index]['title'],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Column(
                        children: [
                          Expanded(child: PieChartWidget()),
                        ],
                      ),
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
