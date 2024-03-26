import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pinput/pinput.dart';
import 'package:school_web/main.dart';
import 'package:school_web/web/routes/pages.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/widgets/ontap_button_widget.dart';

class ConfirmResetPassWord extends StatefulWidget {
  const ConfirmResetPassWord({required this.email, this.loginPass = false, super.key});

  final String email;
  final bool loginPass;

  @override
  State<ConfirmResetPassWord> createState() => _ConfirmResetPassWordState();
}

class _ConfirmResetPassWordState extends State<ConfirmResetPassWord> {
  final GlobalKey<FormState> _formPassKey = GlobalKey<FormState>();
  final TextEditingController codeOtpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final focusNode = FocusNode();

  final isPasswordVisible = false.obs;
  final isConfigPasswordVisible = false.obs;
  final isLoading = false.obs;

  Future<dynamic> recoverAccount(String otp, String newPass) async {
    isLoading(true);

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://backend-shool-project.onrender.com/student/recover-account'),
      );
      request.body = json.encode({
        "verificationCode": otp,
        "newPassword": newPass,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final res = await json.decode(await response.stream.bytesToString());
      if (res['status'] == 'verifiExists') {
        Get.snackbar(
          "Thất bại",
          "Mã xác minh không hợp lệ!",
          backgroundColor: appTheme.errorColor,
          colorText: appTheme.whiteColor,
        );
      } else if (res['status'] == 'expiredExists') {
        Get.snackbar(
          "Thất bại",
          "Mã xác minh đã hết hạn!",
          backgroundColor: appTheme.errorColor,
          colorText: appTheme.whiteColor,
        );
      } else if (res['status'] == 'SUCCESS') {
        Get.snackbar(
          "Thành công",
          "Đặt lại mật khẩu thành công",
          backgroundColor: appTheme.successColor,
          colorText: appTheme.whiteColor,
        );
        Get.toNamed(Routes.SIGNIN);
      } else {
        Get.snackbar(
          "Thất bại",
          "Lỗi thao tác quá nhanh",
          backgroundColor: appTheme.errorColor,
          colorText: appTheme.whiteColor,
        );
      }
    } catch (e) {
      print('Lỗi$e');
    }

    isLoading(false);
  }

  @override
  void dispose() {
    codeOtpController.dispose();
    newPasswordController.dispose();
    confirmPassController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme.transparentColor,
        iconTheme: IconThemeData(color: appTheme.blackColor),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "Nhập mã xác minh và mật khẩu",
                          style: StyleThemeData.styleSize20Weight600(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Nhập mã bao gồm 6 chữ số vừa được gửi đến email ",
                                style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
                              ),
                              TextSpan(text: widget.email, style: StyleThemeData.styleSize15Weight600()),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Form(
                        key: _formPassKey,
                        child: Column(
                          children: [
                            Pinput(
                              length: 6,
                              pinAnimationType: PinAnimationType.slide,
                              controller: codeOtpController,
                              focusNode: focusNode,
                              defaultPinTheme: PinTheme(
                                width: 56,
                                height: 56,
                                textStyle: StyleThemeData.styleSize22Weight400(color: appTheme.primary500Color),
                                decoration: const BoxDecoration(),
                              ),
                              showCursor: true,
                              cursor: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: appTheme.appColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              ),
                              preFilledWidget: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: appTheme.textDesColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Mật khẩu mới',
                                style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Obx(
                              () => TextFormField(
                                controller: newPasswordController,
                                obscureText: !isPasswordVisible.value,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8),
                                  border: const OutlineInputBorder(),
                                  hintText: 'Mật khẩu mới',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      isPasswordVisible.value = !isPasswordVisible.value;
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Mật khẩu mới không được để trống';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Mật khẩu mới',
                                style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Obx(
                              () => TextFormField(
                                controller: confirmPassController,
                                obscureText: !isConfigPasswordVisible.value,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8),
                                  border: const OutlineInputBorder(),
                                  hintText: 'Nhập lại mật khẩu mới',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isConfigPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      isConfigPasswordVisible.value = !isConfigPasswordVisible.value;
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nhập lại mật khẩu mới không được để trống';
                                  } else if (value != newPasswordController.text) {
                                    return 'Mật khẩu nhập lại không khớp';
                                  }

                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Obx(
                        () => OnTaputtonWidget(
                          isLoading: isLoading.value,
                          onTap: () {
                            if (_formPassKey.currentState!.validate()) {
                              recoverAccount(codeOtpController.text, newPasswordController.text);
                            }
                          },
                          text: 'Đặt lại mật khẩu',
                        ),
                      ),
                      const SizedBox(height: 24),
                      widget.loginPass == true
                          ? const SizedBox.shrink()
                          : InkWell(
                              onTap: () {
                                Get.toNamed(Routes.SIGNIN);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Đăng nhập bằng mật khẩu',
                                  style: StyleThemeData.styleSize14Weight400(color: appTheme.appColor),
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
      ),
    );
  }
}
