import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:school_web/web/controllers/auth/auth_controller.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/routes/pages.dart';

class RecoverAccountView extends StatefulWidget {
  const RecoverAccountView({super.key});

  @override
  State<RecoverAccountView> createState() => _RecoverAccountViewState();
}

class _RecoverAccountViewState extends State<RecoverAccountView> {
  final GlobalKey<FormState> _formPassKey = GlobalKey<FormState>();
  final TextEditingController codeOtpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final authController = Get.put(AuthenticationController());

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  Future<dynamic> recoverAccount(String otp, String newPass) async {
    isLoading(true);

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://backend-shool-project.onrender.com/teacher/recover-account'),
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
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (res['status'] == 'expiredExists') {
        Get.snackbar(
          "Thất bại",
          "Mã xác minh đã hết hạn!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (res['status'] == 'SUCCESS') {
        Get.snackbar(
          "Thành công",
          "Đặt lại mật khẩu thành công",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.toNamed(Routes.SIGNIN);
      } else {
        Get.snackbar(
          "Thất bại",
          "Lỗi thao tác quá nhanh",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Lỗi$e');
    }

    isLoading(false);
  }

  @override
  void dispose() {
    super.dispose();
    codeOtpController.dispose();
    newPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Image.asset("assets/images/admin.png", width: 300),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Xác nhận đổi mật khẩu",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 8),
              Form(
                key: _formPassKey,
                child: Column(
                  children: [
                    SizedBox(
                      child: TextFormField(
                        controller: codeOtpController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          FilteringTextInputFormatter.deny(' '),
                          LengthLimitingTextInputFormatter(10),
                        ],
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8),
                          border: OutlineInputBorder(),
                          hintText: 'Code otp',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Code otp không được để trống';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => TextFormField(
                        controller: newPasswordController,
                        obscureText: !isPasswordVisible.value,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[.,-/]')),
                          FilteringTextInputFormatter.deny(' '),
                          LengthLimitingTextInputFormatter(25),
                        ],
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
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formPassKey.currentState!.validate()) {
                        recoverAccount(codeOtpController.text, newPasswordController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                    child: isLoading.value
                        ? const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator()))
                        : const Text(
                            "Xác nhận",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
