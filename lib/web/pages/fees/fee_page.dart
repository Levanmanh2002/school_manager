// // ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/fees/fee_mixin.dart';
import 'package:school_web/web/pages/fees/fee_student_mixin.dart';

class FeePages extends StatefulWidget {
  const FeePages({super.key});

  @override
  State<FeePages> createState() => _FeePagesState();
}

class _FeePagesState extends State<FeePages> with FeeMixin, FeeStudentMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: Responsive.isMobile(context) ? 16 : 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Học phí',
                  style: TextStyle(
                    fontSize: Responsive.isMobile(context) ? 18 : 24,
                    fontWeight: FontWeight.w600,
                    color: appTheme.blackColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              buildTopListDataFee(),
              const SizedBox(height: 24),
              Obx(
                () => (feesController.studentList.isNotEmpty) ? buildListDataStudent() : listDataFees(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
