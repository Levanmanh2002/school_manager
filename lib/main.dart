import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/controllers/teacher/teacher_controller.dart';
import 'package:school_web/web/routes/pages.dart';

Future<void> main() async {
  await GetStorage.init('MyStorage');
  Get.put(AuthenticationController());
  Get.put(const FlutterSecureStorage());
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    GetMaterialApp(
      title: 'EDU',
      initialRoute: Routes.SIGNIN,
      getPages: AppPages.pages,
      theme: ThemeData(
        scaffoldBackgroundColor: primaryBg,
        textTheme: const TextTheme().apply(bodyColor: Colors.black),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        }),
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
