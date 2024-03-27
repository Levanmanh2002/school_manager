import 'package:get/get.dart';
import 'package:school_web/web/pages/authentication/authentication.dart';
import 'package:school_web/web/pages/dashboard/dashboard.dart';
import 'package:school_web/web/pages/majors/majors_pages.dart';
import 'package:school_web/web/pages/other_payment/other_payment_pages.dart';
import 'package:school_web/web/pages/payment_fee/payment_fee_pages.dart';
import 'package:school_web/web/pages/profile/edit_profile_pages.dart';
import 'package:school_web/web/pages/profile/profile_pages.dart';
import 'package:school_web/web/pages/screen/classes/view/add_teacher_classes_view.dart';
import 'package:school_web/web/pages/screen/classes/view/class_info_view.dart';
import 'package:school_web/web/pages/screen/classes/view/add_student_classes_view.dart';
import 'package:school_web/web/pages/screen/student/view/add_student_view.dart';
import 'package:school_web/web/pages/screen/student/view/get_student_view.dart';
import 'package:school_web/web/pages/screen/teacher/view/add_teacher_view.dart';
import 'package:school_web/web/pages/screen/teacher/view/get_teachers_view.dart';
import 'package:school_web/web/pages/screen/teacher/view/recover_account_view.dart';
import 'package:school_web/web/pages/setting/setting_pages.dart';
import 'package:school_web/web/pages/student_transfer/student_transfer_page.dart';
// import 'package:school_web/web/pages/students/students_pages.dart';
// import 'package:school_web/web/pages/students/view/settings_student_view.dart';
import 'package:school_web/web/pages/timetable/timetable.dart';
import 'package:school_web/web/pages/timetable/view/create_view.dart';

part 'routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.SIGNIN,
      page: () => const AuthenticationPage(),
    ),

    /// Main
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const Dashboard(),
    ),

    // GetPage(
    //   name: Routes.HOME,
    //   page: () => const HomePages(),
    // ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfilePages(),
    ),
    GetPage(
      name: Routes.SETTING,
      page: () => const SettingPages(),
    ),
    GetPage(
      name: Routes.ADDTEACHER,
      page: () => const AddTeacherView(),
    ),
    GetPage(
      name: Routes.GETTEACHER,
      page: () => const GetTeachersView(),
    ),
    GetPage(
      name: Routes.GETMAJORS,
      page: () => const MajorsPages(),
    ),
    GetPage(
      name: Routes.ADDSTUDENT,
      page: () => const AddStudentView(),
    ),
    GetPage(
      name: Routes.GETSTUDENT,
      page: () => const GetStudentView(),
    ),
    GetPage(
      name: Routes.CLASSESINFO,
      page: () => const ClassesInfoView(),
    ),
    GetPage(
      name: Routes.ADDSTUDENTCLASS,
      page: () => const AddStudentClassesView(),
    ),
    GetPage(
      name: Routes.ADDTEACHERCLASS,
      page: () => const AddTeacherClassesView(),
    ),
    GetPage(
      name: Routes.EDITPROFILR,
      page: () => const EditProfilePages(),
    ),
    GetPage(
      name: Routes.STUDENTTRANSFER,
      page: () => const StudentTransferPage(),
    ),
    GetPage(
      name: Routes.RECOVERACCOUNT,
      page: () => const RecoverAccountView(),
    ),

    /// Students
    // GetPage(
    //   name: Routes.HOMESTUDENT,
    //   page: () => const StudentsPages(),
    // ),
    // GetPage(
    //   name: Routes.SETTINGSSTUDENT,
    //   page: () => const SettingsStudentView(),
    // ),

    /// Timetable
    GetPage(
      name: Routes.TIMETABLE,
      page: () => const TimetablePage(),
    ),
    GetPage(
      name: Routes.CREATE,
      page: () => const CreateView(),
    ),

    /// Payment
    GetPage(
      name: Routes.OTHERPAYMENT,
      page: () => const OtherPaymentPages(),
    ),
    GetPage(
      name: Routes.PAYMENTFEE,
      page: () => const PaymentFeePages(),
    ),
  ];
}
