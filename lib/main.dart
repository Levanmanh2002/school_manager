import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school_web/web/constants/style.dart';
import 'package:school_web/web/controllers/teacher/teacher_controller.dart';
import 'package:school_web/web/l10n/app_localizations.dart';
import 'package:school_web/web/l10n/language_constants.dart';
import 'package:school_web/web/pages/language/constant.dart';
import 'package:school_web/web/routes/pages.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  runZonedGuarded<Future<void>>(
    () async {
      await GetStorage.init('MyStorage');
      Get.put(AuthenticationController());
      Get.put(const FlutterSecureStorage());
      HttpOverrides.global = MyHttpOverrides();

      runApp(
        const AppSchoolWeb(),
      );
    },
    (error, stack) {
      print("Caught an error: $error");
      print("Stack trace: $stack");
    },
  );
}

class AppSchoolWeb extends StatefulWidget {
  const AppSchoolWeb({super.key});

  static void setLocale(BuildContext context, Locale locale) async {
    AppSchoolWebState? state = context.findAncestorStateOfType<AppSchoolWebState>();
    state?.locale = locale;
  }

  @override
  State<AppSchoolWeb> createState() => AppSchoolWebState();
}

class AppSchoolWebState extends State<AppSchoolWeb> {
  Locale _locale = const Locale("vi");
  final _localeStream = StreamController<Locale?>.broadcast();

  @override
  void initState() {
    super.initState();
    _localeStream.stream.listen((locale) {
      if (locale != null) {
        _locale = locale;

        setLocale(locale.languageCode, locale.countryCode ?? '');
      }
    });
    _localeStream.add(_locale);
    getLocale().then((value) => _localeStream.add(value));
  }

  Locale get locale => _locale;

  set locale(Locale locale) {
    _localeStream.add(locale);
  }

  void handleLanguageChange(Locale locale) async {
    final pref = await SharedPreferences.getInstance();
    (pref.getString(LAGUAGE_CODE) ?? '').isNotEmpty;
    this.locale = locale;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _localeStream.stream,
      initialData: _locale,
      builder: (context, snapshot) => GetMaterialApp(
        title: 'EDU',
        locale: _locale,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          AppLocalizations.delegate,
        ],
        supportedLocales: supportedLocales,
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
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
