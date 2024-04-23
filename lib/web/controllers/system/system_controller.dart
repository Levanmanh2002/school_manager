import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/utils/status/status.dart';

class SystemController extends GetxController {
  var isLoading = false.obs;
  var selectedValue = ''.obs;
  String roleDescription = '';

  Future<void> updateSystem({
    required String teacherId,
    required String system,
    required String user,
    required String grantedById,
  }) async {
    try {
      isLoading(true);

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse('https://backend-shool-project.onrender.com/admin/system'));

      request.body = json.encode({
        "teacherId": teacherId,
        "requestedPermission": system,
        "grantedById": grantedById,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        Get.back();
        showSuccessStatus('Cấp quyền cho $user thành công');
      } else {
        print(response.reasonPhrase);
        showFailStatus('Cấp quyền thất bại');

        isLoading(false);
      }
    } catch (error) {
      print('Lỗi Update system: $error');
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }
}
