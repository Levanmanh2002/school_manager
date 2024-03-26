import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/main.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/controllers/auth_controller.dart';
import 'package:school_web/web/pages/authentication/reset_password.dart';
import 'package:school_web/web/routes/pages.dart';
import 'package:school_web/web/utils/assets/images.dart';
import 'package:school_web/web/widgets/custom_text.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());
  final _teacherCodeController = TextEditingController();
  final _passTeacherController = TextEditingController();
  final isLoading = false.obs;

  Future<dynamic> signinTeacher() async {
    isLoading(true);

    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('https://backend-shool-project.onrender.com/admin/login'));
      request.body = json.encode({
        "teacherCode": _teacherCodeController.text,
        "password": _passTeacherController.text,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var responseBody = await response.stream.bytesToString();
      final res = json.decode(responseBody);

      if (res['status'] == 'wrong_teacher_code') {
        Get.snackbar(
          "Lỗi đăng nhập",
          "Sai mã số giáo viên.",
          backgroundColor: appTheme.errorColor,
          colorText: appTheme.whiteColor,
        );
      } else if (res['status'] == 'wrong_pass') {
        Get.snackbar(
          "Lỗi đăng nhập",
          "Mật khẩu không đúng.",
          backgroundColor: appTheme.errorColor,
          colorText: appTheme.whiteColor,
        );
      } else if (res['status'] == 'SUCCESS') {
        var token = res['token'];

        await const FlutterSecureStorage().write(key: "token", value: token.toString());
        authController.setToken(res["token"]);

        print(token);

        Get.snackbar(
          "Thành công",
          "Đăng nhập thành công!",
          backgroundColor: appTheme.successColor,
          colorText: appTheme.whiteColor,
        );
        authController.getProfileData();
        Get.offAllNamed(Routes.DASHBOARD);

        return res;
      } else {
        Get.snackbar(
          "Thất bại",
          "Lỗi đăng nhập.",
          backgroundColor: appTheme.errorColor,
          colorText: appTheme.whiteColor,
        );

        print("Response Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }

    isLoading(false);
  }

  @override
  void dispose() {
    _teacherCodeController.dispose();
    _passTeacherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  ImagesAssets.adminImage,
                  width: 200,
                ),
                const SizedBox(height: 36),
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: CustomText(
                          text: "Chào mừng quay trở lại bảng quản trị",
                          color: appTheme.lightGrey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _teacherCodeController,
                        decoration: InputDecoration(
                          labelText: "Mã số giáo viên",
                          hintText: "0123456789",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mã số giáo viên không được để trống';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passTeacherController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "123456",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mật khẩu không được để trống';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ResetPasswordStudentsView(
                                title: 'Quên mật khẩu',
                                oftenTitle: 'lấy mật khẩu',
                                loginPass: false,
                                text: 'đặt',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: CustomText(text: "Quên mật khẩu?", color: appTheme.appColor),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Obx(
                        () => InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              signinTeacher();
                            }
                          },
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: appTheme.appColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: isLoading.value
                                ? Center(
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(color: appTheme.whiteColor),
                                    ),
                                  )
                                : CustomText(text: "Đăng nhập", color: appTheme.whiteColor),
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Không có thông tin đăng nhập của quản trị viên? ",
                style: TextStyle(color: dark),
              ),
              TextSpan(text: "Yêu cầu thông tin xác thực! ", style: TextStyle(color: active))
            ],
          ),
        ),
      ),
    );
  }
}
