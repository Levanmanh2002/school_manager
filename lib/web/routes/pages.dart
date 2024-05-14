import 'package:get/get.dart';
import 'package:school_web/web/pages/authentication/authentication.dart';
import 'package:school_web/web/pages/dashboard/dashboard.dart';

part 'routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SIGNIN,
      page: () => const AuthenticationPage(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const Dashboard(),
    ),
  ];
}
