import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/controllers/fees/fees_controller.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/fees/fee_page.dart';
import 'package:school_web/web/pages/fees/view/new_fee_student_view.dart';
import 'package:school_web/web/pages/fees/view/pay_fee_view.dart';
import 'package:school_web/web/pages/fees/widget/item_data_text_widget.dart';
import 'package:school_web/web/pages/fees/widget/item_text_widget.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/build_student_card_widget.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/table_info_student_widget.dart';
import 'package:school_web/web/pages/home/view/mobile/widget/title_tab_widget.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/widgets/box_shadow_widget.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

mixin FeeStudentMixin on State<FeePages> {
  final AuthController authController = Get.put(AuthController());
  final FeesController feesController = Get.put(FeesController());

  Widget buildListDataStudent() {
    return BoxShadowWidget(
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 12 : 24),
      radius: 24,
      child: Obx(
        () => Column(
          children: [
            itemInfoStudent(),
            const SizedBox(height: 8),
            ...feesController.studentList.map((student) {
              return itemStudent();
            }).toList(),
            if (Responsive.isMobile(context)) const SizedBox(height: 8),
            if (Responsive.isMobile(context)) itemButton(),
            if (Responsive.isMobile(context)) const SizedBox(height: 12),
            if (feesController.feesView.value == 1)
              Column(
                children: [
                  const SizedBox(height: 24),
                  ...feesController.studentList
                      .map((student) => student.feesToPay != null && student.feesToPay!.isNotEmpty
                          ? itemFeeStudent(student)
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Chưa có học phí nào', style: StyleThemeData.styleSize14Weight600()),
                            ))
                      .toList(),
                  const SizedBox(height: 24),
                  Obx(
                    () => (feesController.feesHistory.isNotEmpty)
                        ? itemHistoryFeeStudent()
                        : Text('Chưa có lịch sử học phí', style: StyleThemeData.styleSize14Weight600()),
                  ),
                ],
              )
            else if (feesController.feesView.value == 2)
              NewFeeStudentView(studentId: feesController.studentList.first.sId ?? '')
            else if (feesController.feesView.value == 3)
              PayFeeView(student: feesController.studentList.first)
          ],
        ),
      ),
    );
  }

  Widget itemStudent() {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: Responsive.isMobile(context) ? 120 : 100,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Responsive.isMobile(context)
                  ? const SizedBox.shrink()
                  : titleTabWidget(
                      name: 'Họ và tên',
                      code: 'MSSV',
                      industry: 'Ngành nghề',
                      email: 'Email',
                      phone: 'Số điện thoại',
                      status: 'Trạng thái',
                      detail: 'Chi tiết',
                      showDivider: false,
                    ),
              Expanded(
                child: ListView.builder(
                  itemCount: feesController.studentList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final student = feesController.studentList[index];
                    return Responsive.isMobile(context)
                        ? buildStudentCard(student, context)
                        : tableInfoStudentWidget(student, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemInfoStudent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Thông tin học sinh',
          style: StyleThemeData.styleSize18Weight600(),
        ),
        const Spacer(),
        if (!Responsive.isMobile(context)) itemButton()
      ],
    );
  }

  Widget itemFeeStudent(Students student) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Học phí chưa thanh toán',
            style: StyleThemeData.styleSize14Weight600(color: appTheme.blackColor, height: 0),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: appTheme.strokeColor,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  itemTextWidget(context, showStatus: true, showAct: false),
                  Column(
                    children: List.generate(
                      student.feesToPay!.length,
                      (index) {
                        var reversedList = student.feesToPay?.reversed.toList();
                        var data = reversedList?[index];
                        DateTime dueDate = DateTime.parse(data!.hanDongTien!);

                        return itemDataTextWidget(
                          context,
                          searchCode: data.maTraCuu ?? '',
                          content: data.noiDungHocPhi ?? '',
                          soTienPhatHanh: data.soTienPhatHanh.toString(),
                          soTienDong: data.soTienDong.toString(),
                          hanDongTien: DateFormat('dd/MM/yyyy').format(dueDate),
                          showStatus: true,
                          showAct: false,
                          dataStatus: data.status ?? false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget itemHistoryFeeStudent() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Lịch sử đóng học phí',
            style: StyleThemeData.styleSize14Weight600(color: appTheme.blackColor, height: 0),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: appTheme.strokeColor,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  itemTextWidget(context, showStatus: true, showAct: false, dataTime: false),
                  Obx(
                    () => Column(
                      children: List.generate(
                        feesController.feesHistory.length,
                        (index) {
                          var reversedList = feesController.feesHistory.reversed.toList();
                          var data = reversedList[index];
                          if (data.fees != null) {
                            DateTime dueDate = DateTime.parse(data.paymentDate.toString());

                            return itemDataTextWidget(
                              context,
                              searchCode: data.fees?.maTraCuu ?? '',
                              content: data.fees?.noiDungHocPhi ?? '',
                              soTienPhatHanh: data.fees?.soTienPhatHanh.toString() ?? '',
                              soTienDong: data.amountPaid.toString(),
                              hanDongTien: DateFormat('dd/MM/yyyy').format(dueDate),
                              showStatus: true,
                              showAct: false,
                              paymentMethod: data.paymentMethod ?? '',
                              dataTime: false,
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget itemButton() {
    return Responsive.isMobile(context)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: InkWell(
                  onTap: () {
                    if (authController.teacherData.value?.system == 1 ||
                        authController.teacherData.value?.system == 2) {
                      feesController.changeFeesView(2);
                    } else {
                      showNoSystemWidget(
                        context,
                        title: 'Bạn không có quyền',
                        des: 'Xin lỗi, bạn không có quyền truy cập chức năng.',
                        cancel: 'Hủy',
                        confirm: 'Xác nhận',
                        ontap: () => Navigator.pop(context),
                      );
                    }
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: Responsive.isMobile(context) ? 12 : 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: appTheme.appColor),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(IconAssets.coinsIcon, width: 20, height: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Thêm khoản khác',
                          style: StyleThemeData.styleSize14Weight500(color: appTheme.appColor, height: 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: InkWell(
                  onTap: () {
                    if (authController.teacherData.value?.system == 1 ||
                        authController.teacherData.value?.system == 2) {
                      feesController.changeFeesView(3);
                    } else {
                      showNoSystemWidget(
                        context,
                        title: 'Bạn không có quyền',
                        des: 'Xin lỗi, bạn không có quyền truy cập chức năng.',
                        cancel: 'Hủy',
                        confirm: 'Xác nhận',
                        ontap: () => Navigator.pop(context),
                      );
                    }
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: Responsive.isMobile(context) ? 12 : 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: appTheme.appColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(IconAssets.moneyIcon, width: 20, height: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Nộp học phí',
                          style: StyleThemeData.styleSize14Weight500(color: appTheme.whiteColor, height: 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        : Row(
            children: [
              InkWell(
                onTap: () {
                  if (authController.teacherData.value?.system == 1 || authController.teacherData.value?.system == 2) {
                    feesController.changeFeesView(2);
                  } else {
                    showNoSystemWidget(
                      context,
                      title: 'Bạn không có quyền',
                      des: 'Xin lỗi, bạn không có quyền truy cập chức năng.',
                      cancel: 'Hủy',
                      confirm: 'Xác nhận',
                      ontap: () => Navigator.pop(context),
                    );
                  }
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: Responsive.isMobile(context) ? 12 : 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: appTheme.appColor),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(IconAssets.coinsIcon, width: 20, height: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Thêm khoản khác',
                        style: StyleThemeData.styleSize14Weight500(color: appTheme.appColor, height: 0),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () {
                  if (authController.teacherData.value?.system == 1 || authController.teacherData.value?.system == 2) {
                    feesController.changeFeesView(3);
                  } else {
                    showNoSystemWidget(
                      context,
                      title: 'Bạn không có quyền',
                      des: 'Xin lỗi, bạn không có quyền truy cập chức năng.',
                      cancel: 'Hủy',
                      confirm: 'Xác nhận',
                      ontap: () => Navigator.pop(context),
                    );
                  }
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: Responsive.isMobile(context) ? 12 : 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: appTheme.appColor,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(IconAssets.moneyIcon, width: 20, height: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Nộp học phí',
                        style: StyleThemeData.styleSize14Weight500(color: appTheme.whiteColor, height: 0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
