import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/web/models/classes.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/models/teacher.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/home/controller/chart_controller.dart';
import 'package:school_web/web/pages/home/controller/controller.dart';

class OverviewView extends StatefulWidget {
  const OverviewView({required this.controller, super.key});

  final ChartController controller;

  @override
  State<OverviewView> createState() => _OverviewViewState();
}

class _OverviewViewState extends State<OverviewView> {
  final ctl = Get.put(Controller());
  List<StudentData>? newStudentData;
  List<TeacherData>? teacherData;
  List<Classes>? classData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    newStudentData = await ctl.getTotalNewListStudent();
    teacherData = await ctl.getTotalTeacher();
    classData = await ctl.getClassInfo();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final totalStudent = widget.controller.numberOfActiveStudents.value.toDouble() +
        widget.controller.numberOfInactiveStudents.value.toDouble() +
        widget.controller.numberOfSuspendedStudents.value.toDouble() +
        widget.controller.numberOfExpelledStudents.value.toDouble();

    if (Responsive.isMobile(context)) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: itemCartDashboard(
                  context,
                  image: 'assets/images/student.png',
                  data: totalStudent.toString(),
                  text: 'Học sinh',
                ),
              ),
              Expanded(child: _buildItem(context, 'assets/images/student.png', 'Học sinh mới', newStudentData)),
            ],
          ),
          Row(
            children: [
              Expanded(child: _buildItem(context, 'assets/images/teach_image.png', 'Giáo viên', teacherData)),
              Expanded(child: _buildItem(context, 'assets/images/book_image.png', 'Lớp học', classData)),
            ],
          ),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: itemCartCirle(
              context,
              image: 'assets/images/student.png',
              data: totalStudent.toString(),
              text: 'Tất cả học sinh',
            ),
          ),
          Expanded(
            child: _buildItemCirle(context, 'assets/images/student.png', 'Học sinh mới', newStudentData),
          ),
          Expanded(
            child: _buildItemCirle(context, 'assets/images/teach_image.png', 'Tất cả giáo viên', teacherData),
          ),
          Expanded(
            child: _buildItemCirle(context, 'assets/images/book_image.png', 'Lớp học', classData),
          ),
        ],
      );
    }
  }
}

Widget _buildItem<T>(BuildContext context, String image, String text, List<T>? data) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.only(top: 12, bottom: 0, left: 16, right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFECFAFD),
            ),
            child: Image.asset(image, width: 66, height: 66),
          ),
          Column(
            children: [
              Text(
                data?.length.toString() ?? '0',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.5, color: Colors.black),
              ),
              const SizedBox(height: 4),
            ],
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5, color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

Widget _buildItemCirle<T>(BuildContext context, String image, String text, List<T>? data) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data?.length.toString() ?? '0',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    color: Color(0xFF124C72),
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Color(0xFF373743),
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFECFAFD),
            ),
            child: Image.asset(image, width: 41, height: 41),
          ),
        ],
      ),
    ),
  );
}

Widget itemCartDashboard(BuildContext context, {required String image, required String data, required String text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.only(top: 12, bottom: 0, left: 16, right: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFECFAFD),
            ),
            child: Image.asset(image, width: 66, height: 66),
          ),
          Text(
            data,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.5, color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5, color: Colors.black),
          ),
        ],
      ),
    ),
  );
}

Widget itemCartCirle(BuildContext context, {required String image, required String data, required String text}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    color: Color(0xFF124C72),
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: Color(0xFF373743),
                  ),
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFECFAFD),
            ),
            child: Image.asset(image, width: 41, height: 41),
          ),
        ],
      ),
    ),
  );
}
