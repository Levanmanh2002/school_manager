import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/fees/fees_controller.dart';
import 'package:school_web/web/models/fee.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/status/status.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';
import 'package:school_web/web/widgets/popup_successful_widget.dart';

class PayFeeView extends StatefulWidget {
  const PayFeeView({required this.student, super.key});
  final Students student;

  @override
  State<PayFeeView> createState() => _PayFeeViewState();
}

class _PayFeeViewState extends State<PayFeeView> {
  final FeesController feesController = Get.put(FeesController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController soTienDongController = TextEditingController();
  String _selectedPaymentMethod = '';
  String selectedFeesId = '';
  Fees? showSelectedFees;

  @override
  void dispose() {
    super.dispose();
    soTienDongController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Nộp học phí',
              style: StyleThemeData.styleSize18Weight600(),
            ),
          ),
          const SizedBox(height: 24),
          itemDataFeesStudent(),
          const SizedBox(height: 12),
          CustomTextWidgets(
            controller: soTienDongController,
            title: 'Số tiền đóng',
            borderRadius: 8,
            hintText: 'Nhập số tiền đóng',
            validator: true,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          itemButtonPayment(),
          const SizedBox(height: 24),
          itemButton(),
        ],
      ),
    );
  }

  Row itemButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () => feesController.changeFeesView(1),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: appTheme.appColor),
            ),
            child: Text(
              'Hủy',
              style: StyleThemeData.styleSize14Weight600(color: appTheme.appColor, height: 0),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Obx(
          () => InkWell(
            onTap: () {
              if (formKey.currentState!.validate()) {
                if (showSelectedFees != null && selectedFeesId.isNotEmpty) {
                  if (_selectedPaymentMethod.isNotEmpty) {
                    feesController.payTuitionFee(
                      studentId: widget.student.sId.toString(),
                      tuitionFeeId: selectedFeesId,
                      soTienDong: soTienDongController.text,
                      paymentMethod: _selectedPaymentMethod,
                      onSuccess: (_) {
                        popupSuccessfulWidget(
                          context,
                          title: 'Đóng học phí thành công!',
                          des: 'Tra lại mã tra cứu để cập nhật lại trạng thái.',
                          cancel: 'Đóng',
                          confirm: 'Đồng ý',
                          ontapConfirm: () {
                            Get.back();
                            feesController.changeFeesView(1);
                          },
                          ontapCancel: () {
                            Get.back();
                            feesController.changeFeesView(1);
                          },
                        );
                      },
                    );
                  } else {
                    showFailStatus('Vui lòng chọn phương thức thanh toán');
                  }
                } else {
                  showFailStatus('Vui lòng chọn học phí thanh toán');
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              height: 40,
              width: 121,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: appTheme.appColor,
              ),
              child: feesController.isLoadingPay.isTrue
                  ? Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(color: appTheme.whiteColor),
                      ),
                    )
                  : Text(
                      'Xác nhận',
                      style: StyleThemeData.styleSize14Weight600(color: appTheme.whiteColor, height: 0),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget itemDataFeesStudent() {
    String formatDate(String isoString) {
      DateTime dateTime = DateTime.parse(isoString);
      String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

      return formattedDate;
    }

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text('Học phí', style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor)),
              const SizedBox(width: 4),
              Text(
                '*',
                style: StyleThemeData.styleSize14Weight400(color: appTheme.errorColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: appTheme.strokeColor),
          ),
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<Fees>(
                customButton: Container(
                  width: double.infinity,
                  color: (showSelectedFees == null && selectedFeesId.isEmpty) ? null : appTheme.green100Color,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: (showSelectedFees == null && selectedFeesId.isEmpty)
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            'Chọn học phí cần thanh toán',
                            style: StyleThemeData.styleSize14Weight400(height: 0),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Mã tra cứu: ',
                                  style: StyleThemeData.styleSize14Weight600(),
                                ),
                                Text(
                                  showSelectedFees?.maTraCuu ?? '',
                                  style: StyleThemeData.styleSize14Weight600(color: appTheme.appColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tên học phí: ',
                                  style: StyleThemeData.styleSize14Weight400(),
                                ),
                                Flexible(
                                  child: Text(
                                    showSelectedFees?.tenHocPhi ?? '',
                                    style: StyleThemeData.styleSize14Weight600(),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nội dung học phí: ',
                                  style: StyleThemeData.styleSize14Weight400(),
                                ),
                                Flexible(
                                  child: Text(
                                    showSelectedFees?.noiDungHocPhi ?? '',
                                    style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Số tiền đóng: ',
                                  style: StyleThemeData.styleSize14Weight400(),
                                ),
                                Text(
                                  '${showSelectedFees?.soTienDong.toString() ?? ''}đ',
                                  style: StyleThemeData.styleSize14Weight400(color: appTheme.successColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Số tiền nợ: ',
                                  style: StyleThemeData.styleSize14Weight400(),
                                ),
                                Text(
                                  '${showSelectedFees?.soTienNo.toString() ?? ''}đ',
                                  style: StyleThemeData.styleSize14Weight400(color: appTheme.errorColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Trạng thái: ',
                                  style: StyleThemeData.styleSize14Weight400(),
                                ),
                                Text(
                                  showSelectedFees?.status ?? false ? 'Đã đóng' : 'Còn nợ',
                                  style: StyleThemeData.styleSize14Weight400(
                                    color: showSelectedFees?.status ?? false
                                        ? appTheme.successColor
                                        : appTheme.yellow500Color,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            if (showSelectedFees?.hanDongTien != null)
                              Row(
                                children: [
                                  Text(
                                    'Hạn đóng: ',
                                    style: StyleThemeData.styleSize14Weight400(),
                                  ),
                                  Text(
                                    formatDate(showSelectedFees?.hanDongTien.toString() ?? ''),
                                    style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
                                  ),
                                ],
                              ),
                          ],
                        ),
                ),
                items: widget.student.feesToPay
                    ?.map((item) => DropdownMenuItem<Fees>(
                          value: item,
                          child: Text(
                            item.tenHocPhi.toString(),
                            style: StyleThemeData.styleSize14Weight400(),
                          ),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedFeesId = newValue!.sId.toString();
                    showSelectedFees = newValue;
                  });
                },
                iconStyleData: IconStyleData(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: appTheme.textDesColor,
                  ),
                ),
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 50,
                  width: double.maxFinite,
                ),
                dropdownStyleData: const DropdownStyleData(
                  maxHeight: 500,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 60,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget itemButtonPayment() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Text('Phương thức thanh toán', style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor)),
              const SizedBox(width: 4),
              Text(
                '*',
                style: StyleThemeData.styleSize14Weight400(color: appTheme.errorColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: appTheme.strokeColor),
          ),
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  _selectedPaymentMethod.isNotEmpty ? _selectedPaymentMethod : 'Danh sách phương thức thanh toán',
                  style: StyleThemeData.styleSize14Weight400(
                    color: _selectedPaymentMethod.isNotEmpty ? appTheme.blackColor : appTheme.textDesColor,
                  ),
                ),
                items: <String>['Chuyển khoản', 'Tiền mặt']
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: StyleThemeData.styleSize14Weight400(),
                          ),
                        ))
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedPaymentMethod = newValue!;
                  });
                },
                iconStyleData: IconStyleData(
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: _selectedPaymentMethod.isNotEmpty ? appTheme.blackColor : appTheme.textDesColor,
                  ),
                ),
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  height: 50,
                  width: double.maxFinite,
                ),
                dropdownStyleData: const DropdownStyleData(
                  maxHeight: 500,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 60,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
