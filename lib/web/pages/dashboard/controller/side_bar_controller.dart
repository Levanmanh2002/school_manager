import 'package:get/get.dart';
import 'package:school_web/web/pages/home/home_view.dart';
import 'package:school_web/web/pages/majors/majors_pages.dart';
import 'package:school_web/web/pages/notifications/notifications_details.dart';
import 'package:school_web/web/pages/other_payment/other_payment_pages.dart';
import 'package:school_web/web/pages/payment_fee/fee_page.dart';
import 'package:school_web/web/pages/screen/classes/view/class_info_view.dart';
import 'package:school_web/web/pages/screen/student/view/get_student_view.dart';
import 'package:school_web/web/pages/screen/teacher/view/get_teachers_view.dart';
import 'package:school_web/web/pages/student_transfer/student_transfer_page.dart';

class SideBarController extends GetxController {
  RxInt index = 0.obs;

  var pageRoutes = [
    const HomeView(),
    const GetTeachersView(),
    const GetStudentView(),
    const ClassesInfoView(),
    const MajorsPages(),
    const FeePages(),
    const OtherPaymentPages(),
    const StudentTransferPage(),
    const NotificationsDetails(),
  ];
}
