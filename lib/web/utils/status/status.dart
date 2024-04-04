import 'package:get/get.dart';
import 'package:school_web/main.dart';

void showSuccessStatus(
  String message,
) {
  Get.snackbar(
    "Thành công",
    message,
    backgroundColor: appTheme.successColor,
    colorText: appTheme.whiteColor,
  );
}

void showErrorStatus(
  String message,
) {
  Get.snackbar(
    "Lỗi",
    message,
    backgroundColor: appTheme.errorColor,
    colorText: appTheme.whiteColor,
  );
}

void showFailStatus(
  String message,
) {
  Get.snackbar(
    "Thất bại",
    message,
    backgroundColor: appTheme.errorColor,
    colorText: appTheme.whiteColor,
  );
}
