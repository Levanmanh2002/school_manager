// ignore_for_file: constant_identifier_names

part of 'pages.dart';

abstract class Routes {
  /// Main
  static const DASHBOARD = '/dashboard';

  /// Teacher
  static const SIGNIN = '/signin';
  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const SETTING = '/setting';
  static const ADDTEACHER = '/add_teacher';
  static const ADDSTUDENT = '/add_student';
  static const GETTEACHER = '/get_teacher';
  static const GETSTUDENT = '/get_student';
  static const GETMAJORS = '/get_majors';
  static const CLASSESINFO = '/classes';
  static const ADDSTUDENTCLASS = '/add_student_class';
  static const ADDTEACHERCLASS = '/add_teacher_class';
  static const EDITPROFILR = '/edit_profile';
  static const STUDENTTRANSFER = '/student_transfer';
  static const RECOVERACCOUNT = '/recoverAccount';

  /// Students
  static const HOMESTUDENT = '/home_student';
  static const PROFILESTUDENT = '/profile_student';
  static const SETTINGSSTUDENT = '/setting_profile';

  /// Timetable
  static const TIMETABLE = '/timetable';
  static const CREATE = '/create';
}
