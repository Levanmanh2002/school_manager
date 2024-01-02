import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/controllers/teacher/teacher_controller.dart';
import 'package:school_web/web/routes/pages.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final authController = Get.put(AuthenticationController());

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  Future<dynamic> resetPass(String email) async {
    isLoading(true);

    try {
      var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('POST', Uri.parse('https://backend-shool-project.onrender.com/teacher/reset-password'));
      request.body = json.encode({"email": email});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final res = await json.decode(await response.stream.bytesToString());
      if (res['status'] == 'emailExists') {
        Get.snackbar(
          "Thất bại",
          "Email không chính xác!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (res['status'] == 'SUCCESS') {
        Get.snackbar(
          "Thành công",
          "Kiểm tra email của bạn để đặt lại mật khẩu!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Navigator.of(context).pop();
        Get.toNamed(Routes.RECOVERACCOUNT);
        emailController.clear();
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
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Image.asset("assets/images/admin.png", width: 300),
              ),
              const Text('Lấy lại mật khẩu', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                'Nhập địa chỉ email của bạn bên dưới để nhận hướng dẫn lấy lại mật khẩu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 15),
              SizedBox(
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: TextFormField(
                    controller: emailController,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(' '),
                      LengthLimitingTextInputFormatter(50),
                    ],
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(8),
                      border: const OutlineInputBorder(),
                      hintText: authController.teacherData.value?.email ?? 'Email',
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
              ),
              const SizedBox(height: 8),
              Obx(
                () => Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        resetPass(emailController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
                    child: isLoading.value
                        ? const Center(child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator()))
                        : const Text(
                            "Lấy lại mật khẩu",
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
