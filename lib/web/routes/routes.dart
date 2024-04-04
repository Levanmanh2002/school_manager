// ignore_for_file: constant_identifier_names

part of 'pages.dart';

abstract class Routes {
  /// Teacher
  static const SIGNIN = '/signin';

  /// Main
  static const DASHBOARD = '/dashboard';

  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const SETTING = '/setting';
  static const NOTIDETAILS = '/noti_details';
  static const ADDTEACHER = '/add_teacher';
  static const ADDSTUDENT = '/add_student';
  static const GETTEACHER = '/get_teacher';
  static const GETSTUDENT = '/get_student';
  static const GETMAJORS = '/get_majors';
  static const CLASSESINFO = '/classes';
  static const EDITPROFILR = '/edit_profile';
  static const STUDENTTRANSFER = '/student_transfer';

  /// Students
  static const HOMESTUDENT = '/home_student';
  static const SETTINGSSTUDENT = '/setting_profile';

  /// Payment
  static const OTHERPAYMENT = '/other_payment';
  static const PAYMENTFEE = '/payment_fee_pages';
}
