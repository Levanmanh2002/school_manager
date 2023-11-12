// ignore_for_file: unnecessary_type_check

import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/pages/screen/student/detail/student_detail_screen.dart';
import 'package:http/http.dart' as http;

class ExpandedFlex1View extends StatefulWidget {
  const ExpandedFlex1View({super.key});

  @override
  State<ExpandedFlex1View> createState() => _ExpandedFlex1ViewState();
}

class _ExpandedFlex1ViewState extends State<ExpandedFlex1View> {
  final searchController = TextEditingController();
  final isLoading = false.obs;
  String errorMessage = '';
  StudentData? student;
  late DateTime currentWeek = DateTime.now();
  var isLoadingChart = false;

  late DateTime selectedStartTimeDate = DateTime.now();

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

  @override
  void initState() {
    super.initState();
    getCountNewStudents();
    getTimeData();
  }

  String? timeData;

  List<List<Map<String, dynamic>>> studentsList = [];

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
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Container(
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 16),
                width: double.maxFinite,
                height: 300,
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Row(
                      children: [
                        Image.asset("assets/images/admin.png", width: 50),
                        const SizedBox(width: 4),
                        const Text('SHOOL MANAGER', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: InkWell(
                        onTap: () async {
                          await _selectStartTimeDate(context);
                          getCountNewStudents();
                        },
                        child: Container(
                          width: double.maxFinite,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Text(
                            timeData != null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timeData ?? '')))
                                : DateFormat('dd/MM/yyyy').format(selectedStartTimeDate),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  if (studentsList.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Danh sách học sinh',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (var sublist in studentsList)
                          for (var studentMap in sublist) _buildStudentCard(StudentData.fromJson(studentMap), context),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(StudentData studentData, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 1,
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(studentData.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png'),
          radius: 30,
        ),
        title: Text(
          studentData.fullName ?? '',
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(studentData.mssv ?? ''),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentDetailScreen(student: studentData),
            ),
          );
        },
      ),
    );
  }
}

BarTouchData get barTouchData => BarTouchData(
      enabled: false,
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.transparent,
        tooltipPadding: EdgeInsets.zero,
        tooltipMargin: 8,
        getTooltipItem: (BarChartGroupData group, int groupIndex, BarChartRodData rod, int rodIndex) {
          return BarTooltipItem(
            rod.toY.toString(),
            const TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
          );
        },
      ),
    );

Widget getTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Colors.blueAccent,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );
  String text;
  switch (value.toInt()) {
    case 0:
      text = 'Mn';
      break;
    case 1:
      text = 'Te';
      break;
    case 2:
      text = 'Wd';
      break;
    case 3:
      text = 'Tu';
      break;
    case 4:
      text = 'Fr';
      break;
    case 5:
      text = 'St';
      break;
    case 6:
      text = 'Sn';
      break;
    default:
      text = '';
      break;
  }
  return SideTitleWidget(axisSide: meta.axisSide, space: 4, child: Text(text, style: style));
}

FlTitlesData get titlesData => const FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: getTitles,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 50,
        ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );

FlBorderData get borderData => FlBorderData(
      show: false,
    );

LinearGradient get _barsGradient => const LinearGradient(
      colors: [
        Colors.blueAccent,
        Colors.redAccent,
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );

List<BarChartGroupData> barGroups = [];

void updateBarGroups(List<double> toYValues) {
  barGroups = List.generate(
    toYValues.length,
    (index) => BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: toYValues[index],
          gradient: _barsGradient,
        ),
      ],
      showingTooltipIndicators: [0],
    ),
  );
}
