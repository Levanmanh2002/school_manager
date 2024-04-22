import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/models/other.dart';
import 'package:school_web/web/utils/status/status.dart';

class OtherController extends GetxController {
  var otherList = <Other>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUniforms();
  }

  Future<void> fetchUniforms() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/other/uniforms'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        otherList.assignAll(data.map((json) => Other.fromJson(json)).toList());
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Lỗi cập nhật uniforms: $error');
    }
  }

  Future<void> addUniform({
    required String name,
    required String money,
    required String quantity,
    required String note,
    required String blobUrl,
  }) async {
    print(blobUrl);
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://backend-shool-project.onrender.com/other/add-uniform'),
      );

      request.fields.addAll({
        'name': name,
        'money': money,
        'quantity': quantity,
        'note': note,
      });

      var bytes = await getBytesFromBlobUrl(blobUrl);

      var file = http.MultipartFile.fromString(
        'file',
        String.fromCharCodes(bytes),
        filename: 'file',
      );

      request.files.add(file);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        fetchUniforms();

        showSuccessStatus('Thêm thành công');
      } else {
        showFailStatus('Thêm thất bại');
      }
    } catch (error) {
      print('Lỗi add uniform: $error');
    }
  }

  Future<List<int>> getBytesFromBlobUrl(String blobUrl) async {
    var response = await http.get(Uri.parse(blobUrl));
    return response.bodyBytes;
  }

  Future<void> deleteUniform(String id) async {
    try {
      var request = http.Request(
        'DELETE',
        Uri.parse('https://backend-shool-project.onrender.com/other/delete-uniform/$id'),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        fetchUniforms();

        showSuccessStatus('Xóa thành công');
      } else {
        showFailStatus('Xóa thất bại');
      }
    } catch (error) {
      print('Lỗi xóa uniform: $error');
    }
  }
}
