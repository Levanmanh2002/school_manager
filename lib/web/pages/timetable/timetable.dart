import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/base/extension.dart';
import 'package:school_web/web/models/classes.dart';
import 'package:school_web/web/models/majors_models.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/models/timetable.dart';
import 'package:school_web/web/routes/pages.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  List<Timetable> timeTables = [];
  late DateTime currentWeek = DateTime.now();
  Map<String, Map<String, List<Timetable>>> timetablesMap = {};
  String morning = 'MORNING';
  String lunch = 'LUNCH';
  String dinner = 'DINNER';
  var isLoading = false;

  late final dayModeType = <String, String>{morning: 'Sáng', lunch: 'Chiều', dinner: 'Tối'};

  final startMorning = 6;
  final endMoring = 12;
  final startLunch = 12;
  final endLunch = 18;
  final startAfternoon = 18;
  final endAfternoon = 22;

  @override
  void initState() {
    super.initState();
    initializeTimetable();
  }

  DateTime _getStartOfWeek() {
    var startOfWeek = currentWeek.subtract(Duration(days: currentWeek.weekday - 1));
    startOfWeek = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0);
    return startOfWeek;
  }

  DateTime _getEndOfWeek() {
    var endOfWeek = currentWeek.add(Duration(days: 7 - currentWeek.weekday));
    endOfWeek = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59);
    return endOfWeek;
  }

  Future<List<Timetable>> fetchDataFromAPI() async {
    final token = await const FlutterSecureStorage().read(key: 'token');
    var startOfWeek = _getStartOfWeek();
    startOfWeek = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    var endOfWeek = _getEndOfWeek();
    endOfWeek = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59);
    final response = await http.get(
      Uri.parse(
        'https://backend-shool-project.onrender.com/timetable/get-duration?startTime=${startOfWeek.millisecondsSinceEpoch}&endTime=${endOfWeek.millisecondsSinceEpoch}',
      ),
      headers: {'Content-Type': 'application/json', 'Authorization': '$token'},
    );

    final timetables = <Timetable>[];

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      if (data['status'] == "SUCCESS") {
        final timetableList = data['data'];

        for (var timetableData in timetableList) {
          final timetable = Timetable(
            id: timetableData['_id'],
            duration: timetableData['duration'] ?? 0,
            startTime: DateTime.parse(timetableData['startTime']).toLocal(),
            endTime: DateTime.parse(timetableData['endTime']).toLocal(),
            createdAt: DateTime.parse(timetableData['createdAt']).toIso8601String(),
            updatedAt: DateTime.parse(timetableData['updatedAt']).toIso8601String(),
            classId: timetableData['classId'],
            classes: timetableData['class'] != null ? ClassInfoData.fromJson(timetableData['class']) : null,
            teacherId: timetableData['teacherId'],
            teacher: timetableData['teacher'] != null ? TeacherData.fromJson(timetableData['teacher']) : null,
            majorId: timetableData['majorId'],
            majorsData: timetableData['major'] != null ? MajorsData.fromJson(timetableData['major']) : null,
            status: timetableData['status'],
          );

          timetables.add(timetable);
        }
      } else {
        print('API response error: ${data['message']}');
      }
    } else {
      print('API request failed with status code: ${response.statusCode}');
    }

    return timetables;
  }

  initializeTimetable() async {
    isLoading = true;
    setState(() {});
    final fetchedTimetables = await fetchDataFromAPI();
    timeTables.addAll(fetchedTimetables);

    timeTables.sort((a, b) => a.startTime!.compareTo(b.startTime!));
    for (final timetable in timeTables) {
      final key = DateFormat('dd/MM/yyyy').format(timetable.startTime!);
      final type = getTimeTableType(timetable.startTime!, timetable.endTime!);
      if (timetablesMap.containsKey(key)) {
        if (timetablesMap[key]!.containsKey(type)) {
          timetablesMap[key]![type]!.add(timetable);
        } else {
          timetablesMap[key]![type] = [];
          timetablesMap[key]![type]!.add(timetable);
        }
      } else {
        timetablesMap[key] = {};
        if (timetablesMap[key]!.containsKey(type)) {
          timetablesMap[key]![type]!.add(timetable);
        } else {
          timetablesMap[key]![type] = [];
          timetablesMap[key]![type]!.add(timetable);
        }
      }
    }
    isLoading = false;
    setState(() {});
  }

  void deleteTimeTable(Timetable timetable) {
    final key = DateFormat('dd/MM/yyyy').format(timetable.startTime!);
    final type = getTimeTableType(timetable.startTime!, timetable.endTime!);
    final list = timetablesMap[key]![type] ?? [];
    final index = list.indexWhere((element) => element.id == timetable.id);
    if (index != -1) {
      list.removeAt(index);
    }
    setState(() {});
  }

  String getTimeTableType(DateTime startTime, DateTime endTime) {
    var startHour = startTime.hour;
    startHour = startHour == 0 ? 24 : startHour;
    var endHour = endTime.hour;
    endHour = endHour == 0 ? 24 : endHour;
    if (startHour >= startMorning && endHour <= endMoring) {
      return morning;
    } else if (startHour > startLunch) {
      if (endHour <= endLunch) {
        return lunch;
      } else {
        return dinner;
      }
    } else {
      return dinner;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Tạo lịch học dành cho sinh viên',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      currentWeek = currentWeek.subtract(const Duration(days: 7));
                      setState(() {
                        timeTables = [];
                        timetablesMap = {};
                      });
                      initializeTimetable();
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  IconButton(
                    onPressed: () {
                      currentWeek = currentWeek.add(const Duration(days: 7));
                      setState(() {
                        timeTables = [];
                        timetablesMap = {};
                      });
                      initializeTimetable();
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  )
                ],
              ),
              Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        _buildListDay(),
                        ...buildDayMode(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                  if (isLoading) ...[const Center(child: CircularProgressIndicator())]
                ],
              ),
              if (!isLoading && timeTables.isEmpty) ...[
                const SizedBox(height: 12),
                const Text('Tuần này không có lịch')
              ],
              _getData(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  Get.toNamed(Routes.CREATE);
                },
                child: Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.pink,
                  ),
                  child: const Text(
                    'Thêm lịch học',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListDay() {
    final widget = <Widget>[];

    widget.add(
      Container(
        width: 100,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFbdccd6)),
          color: const Color(0xFF042f43),
        ),
      ),
    );
    final days = ['Thứ hai', 'Thứ ba', 'Thứ tư', 'Thứ năm', 'Thứ sáu', 'Thứ bảy', 'Chủ Nhật'];
    for (var i = 0; i < days.length; i++) {
      final day = days[i];
      final time = _getStartOfWeek().add(Duration(days: i));
      final key = DateFormat('dd/MM/yyyy').format(time);
      widget.add(
        Container(
          width: day == '' ? 100 : 300,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFbdccd6)),
            color: time.isToday ? const Color.fromARGB(255, 15, 169, 240) : const Color(0xFF042f43),
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '$day ${time.isToday ? '(Hôm nay)' : ''}\n',
              style: const TextStyle(color: Colors.white),
              children: [TextSpan(text: key)],
            ),
          ),
        ),
      );
    }

    return Row(children: widget);
  }

  List<Widget> buildDayMode() {
    return dayModeType.keys
        .map(
          (key) => IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFbdccd6)),
                  ),
                  child: Text(dayModeType[key] ?? ''),
                ),
                ...List.generate(7, (index) => buildListTimeableInDayModeKey(key, index))
              ],
            ),
          ),
        )
        .toList();
  }

  Row buildListTimeableInDayModeKey(String key, int index) {
    final widgets = <Widget>[];
    final day = _getStartOfWeek().add(Duration(days: index));
    final dayKey = DateFormat('dd/MM/yyyy').format(day);
    if (timetablesMap.containsKey(dayKey)) {
      final data = timetablesMap[dayKey]![key] ?? [];
      if (data.isEmpty) {
        widgets.add(Container(
          width: 300,
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFbdccd6)),
          ),
        ));
      } else {
        widgets.add(buildTimetable(data));
      }
    } else {
      widgets.add(
        Container(
          width: 300,
          height: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFbdccd6)),
          ),
        ),
      );
    }
    return Row(children: widgets);
  }

  Widget buildTimetable(List<Timetable> timetables) {
    return Column(
        children: timetables.map(
      (e) {
        final startTime = DateFormat.Hm().format(e.startTime!);
        final endTime = DateFormat.Hm().format(e.endTime!);
        return GestureDetector(
          onDoubleTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Xác nhận",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  content: const Text(
                    "Bạn có chắc chắn muốn xóa thời khóa biểu này?",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        "Hủy",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      child: const Text(
                        "Đồng ý",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red),
                      ),
                      onPressed: () {
                        deleteTimeTable(e);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            width: 300,
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFbdccd6)),
            ),
            child: Column(
              children: [
                Text(
                  e.classes?.className ?? '',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF991148)),
                ),
                Text(
                  '$startTime - $endTime',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF0f2e94)),
                ),
                Text(
                  e.majorsData?.name ?? '',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF0a4358)),
                ),
                Text(
                  e.teacher?.fullName ?? '',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.blue),
                ),
              ],
            ),
          ),
        );
      },
    ).toList());
  }

  Widget buildData(List<Timetable> timetables) {
    return Column(
        children: timetables.map(
      (e) {
        final startTime = DateFormat.Hm().format(e.startTime!);
        final endTime = DateFormat.Hm().format(e.endTime!);
        return GestureDetector(
          onDoubleTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Xác nhận",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  content: const Text(
                    "Bạn có chắc chắn muốn xóa thời khóa biểu này?",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text(
                        "Hủy",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      child: const Text(
                        "Đồng ý",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red),
                      ),
                      onPressed: () {
                        deleteTimeTable(e);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            width: 300,
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFbdccd6)),
            ),
            child: Column(
              children: [
                Text(
                  e.classes?.className ?? '',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF991148)),
                ),
                Text(
                  '$startTime - $endTime',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF0f2e94)),
                ),
                Text(
                  e.majorsData?.name ?? '',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF0a4358)),
                ),
                Text(
                  e.teacher?.fullName ?? '',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.blue),
                ),
              ],
            ),
          ),
        );
      },
    ).toList());
  }

  Widget _getData() {
    return Container(
      padding: const EdgeInsets.only(top: 30, left: 16, right: 16, bottom: 16),
      child: Column(
        children: timeTables.map(
          (e) {
            final startTime = DateFormat.Hm().format(e.startTime!);
            final endTime = DateFormat.Hm().format(e.endTime!);
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFbdccd6)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Lớp học trong tuần : ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        e.classes?.className ?? '',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF991148)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Thời gian học của lớp',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ' ${e.classes?.className} ',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF991148),
                              ),
                            ),
                            const TextSpan(
                              text: 'trong tuần : ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$startTime - $endTime',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF0f2e94)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                            text: 'Ngành học của lớp',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: ' ${e.classes?.className} ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF991148),
                            ),
                          ),
                          const TextSpan(
                            text: 'trong tuần : ',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        e.majorsData?.name ?? 'null',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF0a4358)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Giáo viên dạy lớp',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ' ${e.classes?.className} ',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF991148),
                              ),
                            ),
                            const TextSpan(
                              text: 'trong tuần : ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        e.teacher?.fullName ?? '', // Hiển thị tên giáo viên ở đây
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  bool isToday(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final inputDate = DateTime(date.year, date.month, date.day);
    return today.isAtSameMomentAs(inputDate);
  }
}
