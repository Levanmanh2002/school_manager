// ignore_for_file: unnecessary_type_check

import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/screen/student/detail/student_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/widgets/full_screen_image_screen.dart';

class ExpandedFlex1View extends StatefulWidget {
  const ExpandedFlex1View({super.key});

  @override
  State<ExpandedFlex1View> createState() => _ExpandedFlex1ViewState();
}

class _ExpandedFlex1ViewState extends State<ExpandedFlex1View> {
  final searchController = TextEditingController();
  bool _isClearIconVisible = false;
  final isLoading = false.obs;
  String errorMessage = '';
  StudentData? student;
  late DateTime currentWeek = DateTime.now();
  var isLoadingChart = false;

  @override
  void initState() {
    searchController.addListener(_onTextChanged);
    initializeTimetable();
    super.initState();
  }

  void _onTextChanged() {
    setState(() {
      _isClearIconVisible = searchController.text.isNotEmpty;
    });
  }

  Future<void> fetchData(String query) async {
    isLoading(true);

    try {
      final response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/user/check/$query'));

      if (response.statusCode == 404) {
        setState(() {
          errorMessage = 'Không tìm thấy học sinh';
          student = null;
        });
      } else if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        final studentData = jsonData['student'];

        setState(() {
          student = StudentData.fromJson(studentData);
          errorMessage = '';
        });
      } else {
        print('Failed to fetch data: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi: $e';
        student = null;
      });
    }

    isLoading(false);
  }

  /// Fake
  Future<List<StudentData>> _getActiveStudent() async {
    var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/students/active'));

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> data = responseData['data'];

      if (data is List) {
        List<StudentData> student = data.map((studentData) => StudentData.fromJson(studentData)).toList();
        student.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

        return student = student.reversed.toList();
      } else {
        throw Exception('Invalid data format');
      }
    } else {
      throw Exception('Failed to load working student');
    }
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

  Future<void> getCountNewStudents() async {
    var startOfWeek = _getStartOfWeek();
    startOfWeek = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    var endOfWeek = _getEndOfWeek();
    endOfWeek = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59);

    final response = await http.get(
      Uri.parse(
        'https://backend-shool-project.onrender.com/chart/countNewStudents?startDate=${startOfWeek.millisecondsSinceEpoch}&endDate=${endOfWeek.millisecondsSinceEpoch}',
      ),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      final decodedData = json.decode(data);
      final parsedData = decodedData['data'] as int?;
      print(parsedData);
    } else {
      print(response.reasonPhrase);
    }
  }

  initializeTimetable() async {
    await getCountNewStudents();
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
                  Container(
                    padding: const EdgeInsets.only(right: 16),
                    width: Responsive.isMobile(context)
                        ? Responsive.isTablet(context)
                            ? 100
                            : 100
                        : 300,
                    height: 35,
                    alignment: Alignment.bottomCenter,
                    child: TextFormField(
                      controller: searchController,
                      onChanged: fetchData,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm",
                        suffixIcon: _isClearIconVisible
                            ? IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  student = null;
                                },
                                icon: const Icon(Icons.clear, size: 16, color: Colors.pink))
                            : null,
                        contentPadding: const EdgeInsets.only(top: 1, left: 8),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD2D5DA)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.maxFinite,
                height: 500,
                child: FutureBuilder<List<StudentData>>(
                  future: _getActiveStudent(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Không có học sinh nào.'));
                    } else {
                      return (_isClearIconVisible)
                          ? Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: (student != null) ? Colors.grey[200] : Colors.white,
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  if (errorMessage.isNotEmpty)
                                    Text(
                                      errorMessage,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  if (student != null)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Card(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            elevation: 1,
                                            color: Colors.white,
                                            child: ListTile(
                                              leading: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => FullScreenImageScreen(
                                                        imageUrl:
                                                            student?.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png',
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    student?.avatarUrl ?? 'https://i.stack.imgur.com/l60Hf.png',
                                                  ),
                                                  radius: 30,
                                                ),
                                              ),
                                              title: Text(
                                                student?.fullName ?? '',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle: Text(student?.mssv ?? ''),
                                              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => StudentDetailScreen(student: student!),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                const SizedBox(height: 16),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Danh sách học sinh : ${snapshot.data?.length}',
                                    style:
                                        const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.green),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      final student = snapshot.data![index];
                                      return _buildStudentCard(student, context);
                                    },
                                  ),
                                ),
                              ],
                            );
                    }
                  },
                ),
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

List<BarChartGroupData> get barGroups => [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: 100,
            gradient: _barsGradient,
          ),
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: 300,
            gradient: _barsGradient,
          ),
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: 400,
            gradient: _barsGradient,
          ),
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            toY: 100,
            gradient: _barsGradient,
          ),
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [
          BarChartRodData(
            toY: 490,
            gradient: _barsGradient,
          ),
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 5,
        barRods: [
          BarChartRodData(
            toY: 390,
            gradient: _barsGradient,
          ),
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 6,
        barRods: [
          BarChartRodData(
            toY: 200,
            gradient: _barsGradient,
          ),
        ],
        showingTooltipIndicators: [0],
      ),
    ];
