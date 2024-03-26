// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/main.dart';
import 'package:school_web/web/pages/authentication/confirm_reset_password.dart';
import 'package:school_web/web/style/style_theme.dart';
import 'package:school_web/web/widgets/ontap_button_widget.dart';

class ResetPasswordStudentsView extends StatefulWidget {
  const ResetPasswordStudentsView({
    required this.title,
    required this.oftenTitle,
    this.loginPass = false,
    required this.text,
    super.key,
  });
  final String title;
  final String oftenTitle;
  final bool loginPass;
  final String text;

  @override
  State<ResetPasswordStudentsView> createState() => _ResetPasswordStudentsViewState();
}

class _ResetPasswordStudentsViewState extends State<ResetPasswordStudentsView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  final isLoading = false.obs;

  Future<dynamic> resetPass(String email) async {
    isLoading(true);

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://backend-shool-project.onrender.com/student/reset-password'),
      );
      request.body = json.encode({"gmail": email});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final res = await json.decode(await response.stream.bytesToString());
      if (res['status'] == 'emailExists') {
        Get.snackbar(
          "Thất bại",
          "Email không chính xác!",
          backgroundColor: appTheme.errorColor,
          colorText: appTheme.whiteColor,
        );
      } else if (res['status'] == 'SUCCESS') {
        Get.snackbar(
          "Thành công",
          "Kiểm tra email của bạn để ${widget.text} lại mật khẩu!",
          backgroundColor: appTheme.successColor,
          colorText: appTheme.whiteColor,
        );
        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ConfirmResetPassWord(email: emailController.text, loginPass: widget.loginPass),
          ),
        );
        emailController.clear();
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
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: appTheme.whiteColor,
        iconTheme: IconThemeData(color: appTheme.blackColor),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          alignment: Alignment.center,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.title,
                        style: StyleThemeData.styleSize20Weight600(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Vui lòng nhập Email để ${widget.oftenTitle}',
                        style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Email',
                        style: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(8),
                          border: const OutlineInputBorder(),
                          hintText: 'Nhập Email',
                          hintStyle: StyleThemeData.styleSize14Weight400(color: appTheme.textDesColor),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email không được để trống';
                          } else if (!value.contains('@')) {
                            return 'Email không hợp lệ';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => OnTaputtonWidget(
                        isLoading: isLoading.value,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            resetPass(emailController.text);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
