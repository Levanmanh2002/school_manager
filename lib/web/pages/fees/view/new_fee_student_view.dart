import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/controllers/fees/fees_controller.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/utils/formatter/no_initial_spaceInput_formatter_widgets.dart';
import 'package:school_web/web/widgets/custom_text_widgets.dart';

class NewFeeStudentView extends StatefulWidget {
  const NewFeeStudentView({required this.studentId, super.key});
  final String studentId;

  @override
  State<NewFeeStudentView> createState() => _NewFeeStudentViewState();
}

class _NewFeeStudentViewState extends State<NewFeeStudentView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FeesController feesController = Get.put(FeesController());

  final TextEditingController nameFeeController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController paidAmountDataController = TextEditingController();
  final TextEditingController paymentDateController = TextEditingController();
  final TextEditingController issuedAmountDataController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameFeeController.dispose();
    contentController.dispose();
    paidAmountDataController.dispose();
    paymentDateController.dispose();
    issuedAmountDataController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Thêm khoản khác',
              style: StyleThemeData.styleSize18Weight600(),
            ),
          ),
          const SizedBox(height: 24),
          CustomTextWidgets(
            controller: nameFeeController,
            title: 'Tên học phí',
            borderRadius: 8,
            hintText: 'Nhập tên học phí',
            validator: true,
          ),
          const SizedBox(height: 12),
          itemContentField(),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                child: CustomTextWidgets(
                  controller: issuedAmountDataController,
                  title: 'Số tiền phát hành',
                  borderRadius: 8,
                  hintText: 'Nhập số tiền phát hành',
                  validator: true,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: CustomTextWidgets(
                  controller: paidAmountDataController,
                  title: 'Số tiền đóng',
                  borderRadius: 8,
                  hintText: 'Nhập số tiền đóng',
                  validator: true,
                ),
              ),
              const SizedBox(width: 12),
              Flexible(
                child: CustomTextWidgets(
                  controller: paymentDateController,
                  title: 'Hạn đóng',
                  borderRadius: 8,
                  hintText: 'Nhập hạn đóng',
                  validator: true,
                ),
              ),
            ],
          ),
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
                feesController.addTuitionFeeToStudent(
                  widget.studentId,
                  tenHocPhi: nameFeeController.text,
                  noiDungHocPhi: contentController.text,
                  soTienPhatHanh: issuedAmountDataController.text,
                  soTienDong: paidAmountDataController.text,
                  hanDongTien: paymentDateController.text,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              width: 180,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: appTheme.appColor,
              ),
              child: feesController.isLoadingAddFeesStudent.isTrue
                  ? Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(color: appTheme.whiteColor),
                      ),
                    )
                  : Text(
                      'Xác nhận khoản phí',
                      style: StyleThemeData.styleSize14Weight600(color: appTheme.whiteColor, height: 0),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Column itemContentField() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Nội dung',
                style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: StyleThemeData.styleSize14Weight400(color: appTheme.errorColor),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: contentController,
          maxLines: 5,
          inputFormatters: [
            LengthLimitingTextInputFormatter(300),
            NoInitialSpaceInputFormatterWidgets(),
          ],
          decoration: InputDecoration(
            hintText: 'Nhập nội dung',
            hintStyle: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor, height: 0),
            contentPadding: const EdgeInsets.all(12),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.errorColor),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: appTheme.errorColor),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFD2D5DA)),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFD2D5DA)),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Thông tin không được để trống';
            }

            return null;
          },
        ),
      ],
    );
  }
}
