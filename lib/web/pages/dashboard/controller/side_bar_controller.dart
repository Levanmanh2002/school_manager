import 'package:get/get.dart';
import 'package:school_web/web/pages/home/home_view.dart';
import 'package:school_web/web/pages/majors/majors_pages.dart';
import 'package:school_web/web/pages/notifications/notifications_details.dart';
import 'package:school_web/web/pages/other_payment/other_payment_pages.dart';
import 'package:school_web/web/pages/payment_fee/fee_page.dart';
import 'package:school_web/web/pages/screen/classes/view/class_info_view.dart';
import 'package:school_web/web/pages/screen/student/view/add_student_view.dart';
import 'package:school_web/web/pages/screen/student/view/get_student_view.dart';
import 'package:school_web/web/pages/screen/teacher/view/add_teacher_view.dart';
import 'package:school_web/web/pages/screen/teacher/view/get_teachers_view.dart';
import 'package:school_web/web/pages/student_transfer/student_transfer_page.dart';

class SideBarController extends GetxController {
  RxInt index = 0.obs;

  var pageRoutes = [
    const HomeView(), // 0
    const GetTeachersView(), // 1
    const GetStudentView(), // 2
    const ClassesInfoView(), // 3
    const MajorsPages(), // 4
    const FeePages(), // 5
    const OtherPaymentPages(), // 6
    const StudentTransferPage(), // 7
    const NotificationsDetails(), // 8
    const AddTeacherView(), // 9
    const AddStudentView(), // 10
  ];
}
