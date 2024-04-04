// // ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:school_web/web/controllers/fees/fees_controller.dart';
import 'package:school_web/web/models/fee.dart';
import 'package:school_web/web/pages/dashboard/config/responsive.dart';
import 'package:school_web/web/pages/fees/widget/item_data_text_widget.dart';
import 'package:school_web/web/pages/fees/widget/item_text_widget.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/assets/icons.dart';
import 'package:school_web/web/widgets/show_dialog/show_no_system_widget.dart';

class FeePages extends StatefulWidget {
  const FeePages({super.key});

  @override
  State<FeePages> createState() => _FeePagesState();
}

class _FeePagesState extends State<FeePages> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthenticationController authController = Get.put(AuthenticationController());
  final FeesController feesController = Get.put(FeesController());

  final TextEditingController tenHocPhiController = TextEditingController();
  final TextEditingController noiDungHocPhiController = TextEditingController();
  final TextEditingController soTienPhatHanhController = TextEditingController();
  final TextEditingController soTienDongController = TextEditingController();
  final TextEditingController hanDongTienController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    tenHocPhiController.dispose();
    noiDungHocPhiController.dispose();
    soTienPhatHanhController.dispose();
    soTienDongController.dispose();
    hanDongTienController.dispose();
  }

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
              Container(
                padding: EdgeInsets.all(Responsive.isMobile(context) ? 12 : 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: appTheme.whiteColor,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Thông tin học phí',
                          style: StyleThemeData.styleSize18Weight600(),
                        ),
                        InkWell(
                          onTap: () {
                            if (authController.teacherData.value?.system == 1 ||
                                authController.teacherData.value?.system == 2) {
                              _showCreateAndEditFeeDialog(context);
                            } else {
                              showNoSystemWidget(
                                context,
                                title: 'Bạn không có quyền giáo viên',
                                des: 'Xin lỗi, bạn không có quyền truy cập chức năng của giáo viên.',
                                cancel: 'Hủy',
                                confirm: 'Xác nhận',
                                ontap: () => Navigator.pop(context),
                              );
                            }
                          },
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(vertical: 8, horizontal: Responsive.isMobile(context) ? 12 : 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: appTheme.appColor),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(IconAssets.coinsIcon),
                                const SizedBox(width: 8),
                                Text(
                                  'Thêm học phí mới',
                                  style: StyleThemeData.styleSize14Weight500(color: appTheme.appColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: appTheme.strokeColor,
                      ),
                      child: SizedBox(
                        width: Responsive.isMobile(context)
                            ? MediaQuery.of(context).size.width / 1.3
                            : MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              itemTextWidget(context),
                              Obx(
                                () => Column(
                                  children: List.generate(
                                    feesController.filteredFeesList.length,
                                    (index) {
                                      var reversedList = feesController.filteredFeesList.reversed.toList();
                                      var fees = reversedList[index];
                                      DateTime dueDate = DateTime.parse(fees.hanDongTien!);

                                      return itemDataTextWidget(
                                        context,
                                        editOnTap: () {
                                          if (authController.teacherData.value?.system == 1 ||
                                              authController.teacherData.value?.system == 2 ||
                                              authController.teacherData.value?.system == 3) {
                                            _showCreateAndEditFeeDialog(context, fees: fees, editStatus: true);
                                          } else {
                                            showNoSystemWidget(
                                              context,
                                              title: 'Bạn không có quyền giáo viên',
                                              des: 'Xin lỗi, bạn không có quyền truy cập chức năng của giáo viên.',
                                              cancel: 'Hủy',
                                              confirm: 'Xác nhận',
                                              ontap: () => Navigator.pop(context),
                                            );
                                          }
                                        },
                                        deleteOnTap: () {
                                          if (authController.teacherData.value?.system == 1 ||
                                              authController.teacherData.value?.system == 2) {
                                            showNoSystemWidget(
                                              context,
                                              title: 'Xác nhận xóa học phí?',
                                              des: 'Bạn có chắc chắn muốn xóa, không thể khôi phục khi đã xóa? ',
                                              cancel: 'Hủy',
                                              confirm: 'Xác nhận',
                                              ontap: () {
                                                Navigator.of(context).pop();
                                                feesController.deleteTuitionFees(
                                                  fees.feesIds ?? '',
                                                  fees.maTraCuu ?? '',
                                                );
                                              },
                                            );
                                          } else {
                                            showNoSystemWidget(
                                              context,
                                              title: 'Bạn không có quyền giáo viên',
                                              des: 'Xin lỗi, bạn không có quyền truy cập chức năng của giáo viên.',
                                              cancel: 'Hủy',
                                              confirm: 'Xác nhận',
                                              ontap: () => Navigator.pop(context),
                                            );
                                          }
                                        },
                                        searchCode: fees.maTraCuu ?? '',
                                        content: fees.noiDungHocPhi ?? '',
                                        soTienPhatHanh: fees.soTienPhatHanh.toString(),
                                        soTienDong: fees.soTienDong.toString(),
                                        hanDongTien: DateFormat('dd-MM-yyyy').format(dueDate),
                                      );
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showCreateAndEditFeeDialog(BuildContext context, {Fees? fees, bool editStatus = false}) {
    tenHocPhiController.text = fees?.tenHocPhi.toString() ?? '';
    noiDungHocPhiController.text = fees?.noiDungHocPhi.toString() ?? '';
    soTienPhatHanhController.text = fees?.soTienPhatHanh.toString() ?? '';
    soTienDongController.text = fees?.soTienDong.toString() ?? '';
    hanDongTienController.text = fees?.hanDongTien.toString() ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(
            editStatus ? 'Chỉnh sửa học phí' : 'Tạo học phí mới',
            style: StyleThemeData.styleSize16Weight800(),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420, minWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    itemInput(
                      title: 'Tên học phí',
                      controller: tenHocPhiController,
                      hintText: 'Nhập tên học phí',
                      textValue: 'Tên học phí không được để trống',
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 24),
                    itemInput(
                      title: 'Nội dung học phí',
                      controller: noiDungHocPhiController,
                      hintText: 'Nhập nội dung học phí',
                      textValue: 'Nội dung học phí không được để trống',
                      keyboardType: TextInputType.text,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 24),
                    itemInput(
                      title: 'Số tiền phát hành',
                      controller: soTienPhatHanhController,
                      hintText: 'Nhập số tiền phát hành',
                      textValue: 'Số tiền phát hành không được để trống',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    itemInput(
                      title: 'Số tiền phải đóng',
                      controller: soTienDongController,
                      hintText: 'Nhập số tiền phải đóng',
                      textValue: 'Số tiền phải đóng không được để trống',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 24),
                    itemInput(
                      title: 'Hạn đóng học phí',
                      controller: hanDongTienController,
                      hintText: 'Nhập hạn đóng học phí',
                      textValue: 'Hạn đóng học phí không được để trống',
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                            tenHocPhiController.clear();
                            noiDungHocPhiController.clear();
                            soTienPhatHanhController.clear();
                            soTienDongController.clear();
                            hanDongTienController.clear();
                          },
                          child: Container(
                            height: 35,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: appTheme.whiteColor,
                              border: Border.all(color: appTheme.textDesColor),
                            ),
                            child: Text(
                              'Hủy',
                              style: StyleThemeData.styleSize16Weight600(color: appTheme.textDesColor, height: 0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Obx(
                          () => InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                if (editStatus == false) {
                                  await feesController.createTuitionFee(
                                    tenHocPhi: tenHocPhiController.text,
                                    noiDungHocPhi: noiDungHocPhiController.text,
                                    soTienPhatHanh: soTienPhatHanhController.text,
                                    soTien: soTienDongController.text,
                                    hanDongTien: hanDongTienController.text,
                                  );
                                } else {
                                  await feesController.updateTuitionFees(
                                    fees?.feesIds.toString() ?? '',
                                    tenHocPhi: tenHocPhiController.text,
                                    noiDungHocPhi: noiDungHocPhiController.text,
                                    soTienPhatHanh: soTienPhatHanhController.text,
                                    soTienDong: soTienDongController.text,
                                    hanDongTien: hanDongTienController.text,
                                  );
                                }

                                tenHocPhiController.clear();
                                noiDungHocPhiController.clear();
                                soTienPhatHanhController.clear();
                                soTienDongController.clear();
                                hanDongTienController.clear();
                              }
                            },
                            child: Container(
                              width: 120,
                              height: 35,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: appTheme.appColor,
                              ),
                              child: feesController.isLoadingCreate.isTrue || feesController.isLoadingUpdate.isTrue
                                  ? Center(
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(color: appTheme.whiteColor),
                                      ),
                                    )
                                  : Text(
                                      editStatus ? 'Chỉnh sửa' : 'Xác nhận',
                                      style: StyleThemeData.styleSize16Weight600(color: appTheme.whiteColor, height: 0),
                                      textAlign: TextAlign.center,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget itemInput({
    required String title,
    required TextEditingController controller,
    required String hintText,
    required String textValue,
    TextInputType? keyboardType,
    int? maxLines = 1,
  }) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text(
                title,
                style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
              ),
              const SizedBox(width: 4),
              Text('*', style: TextStyle(color: appTheme.errorColor)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          inputFormatters: [
            LengthLimitingTextInputFormatter(300),
          ],
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: StyleThemeData.styleSize14Weight400(color: const Color(0xFFB6BBC3)),
            errorStyle: TextStyle(color: appTheme.errorColor),
            labelStyle: StyleThemeData.styleSize14Weight400(height: 0),
            border: const OutlineInputBorder(),
            prefix: const SizedBox(width: 12),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.errorColor),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD2D5DA)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFD2D5DA)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return textValue;
            }

            return null;
          },
        ),
      ],
    );
  }
}
