import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:school_web/web/models/fee.dart';
import 'package:school_web/web/models/fees_history.dart';
import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/utils/status/status.dart';

class FeesController extends GetxController {
  var feesList = <Fees>[].obs;
  var studentList = <Students>[].obs;
  var feesHistory = <FeesHistory>[].obs;
  var filteredFeesList = <Fees>[].obs;

  var isLoadingSearch = false.obs;
  var isLoadingUpdate = false.obs;
  var isLoadingCreate = false.obs;
  var isLoadingAddFeesStudent = false.obs;
  var isLodingUpdateFeeToStudent = false.obs;
  var isLoadingPay = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTuitionFees();
  }

  Future<void> fetchTuitionFees() async {
    try {
      var response = await http.get(Uri.parse('https://backend-shool-project.onrender.com/admin/tuition_fees'));

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body)['data'];

        feesList.assignAll(data.map((e) => Fees.fromJson(e)).toList());
        filteredFeesList.assignAll(feesList);
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Lỗi Tuition Fees: $error');
    }
  }

  Future<void> searchStudent(String searchQuery) async {
    try {
      isLoadingSearch(true);
      var response = await http.post(
        Uri.parse('https://backend-shool-project.onrender.com/search/mssv?searchQuery=$searchQuery'),
      );

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body)['data'];

        studentList.assignAll(data.map((e) => Students.fromJson(e)).toList());

        await feesHistoryStudent(studentList.first.sId!);

        isLoadingSearch(false);
      } else {
        print(response.reasonPhrase);
        isLoadingSearch(false);
      }
    } catch (error) {
      print('Lỗi search student: $error');
      isLoadingSearch(false);
    } finally {
      isLoadingSearch(false);
    }
  }

  Future<void> createTuitionFee({
    required String tenHocPhi,
    required String noiDungHocPhi,
    required String soTienPhatHanh,
    required String soTien,
    required String hanDongTien,
  }) async {
    try {
      isLoadingCreate(true);

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://backend-shool-project.onrender.com/admin/create_tuition_fee'),
      );
      request.body = json.encode({
        "tenHocPhi": tenHocPhi,
        "noiDungHocPhi": noiDungHocPhi,
        "soTienPhatHanh": soTienPhatHanh,
        "soTienDong": soTien,
        "soTienNo": soTien,
        "hanDongTien": '2024-03-01T00:00:00.000Z',
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      final res = await json.decode(await response.stream.bytesToString());

      if (res['status'] == 'ERRORCODE') {
        showErrorStatus('Mã tra cứu đã tồn tại trong cơ sở dữ liệu');

        isLoadingCreate(false);
      } else if (res['status'] == 'SUCCESS') {
        fetchTuitionFees();
        Get.back();

        showSuccessStatus('Thêm học phí thành công');

        isLoadingCreate(false);
      }
    } catch (error) {
      print('Lỗi create tuition fee: $error');
      isLoadingCreate(false);
    } finally {
      isLoadingCreate(false);
    }
  }

  Future<void> updateTuitionFees(
    String tuitionFeeId, {
    required String tenHocPhi,
    required String noiDungHocPhi,
    required String soTienPhatHanh,
    required String soTienDong,
    required String hanDongTien,
  }) async {
    try {
      isLoadingUpdate(true);

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'PUT',
        Uri.parse('https://backend-shool-project.onrender.com/admin/update_tuition_fee/$tuitionFeeId'),
      );
      request.body = json.encode({
        "tenHocPhi": tenHocPhi,
        "noiDungHocPhi": noiDungHocPhi,
        "soTienPhatHanh": soTienPhatHanh,
        "soTienDong": soTienDong,
        "hanDongTien": '2024-03-01T00:00:00.000Z',
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        isLoadingUpdate(false);
        fetchTuitionFees();
        Get.back();
        showSuccessStatus('Đã chỉnh sửa thành công');
      } else {
        showFailStatus('Chỉnh sửa thất bại. Vui lòng thử lại');

        print(response.reasonPhrase);
        isLoadingUpdate(false);
      }
    } catch (error) {
      print('Lỗi update tuition fee: $error');
      isLoadingUpdate(false);
    } finally {
      isLoadingUpdate(false);
    }
  }

  Future<void> deleteTuitionFees(String tuitionFeeId, String data) async {
    try {
      var response = await http.delete(
        Uri.parse('https://backend-shool-project.onrender.com/admin/delete_tuition_fee/$tuitionFeeId'),
      );
      if (response.statusCode == 201) {
        fetchTuitionFees();

        showSuccessStatus('Đã xóa học phí $data thành công');
      } else {
        showFailStatus('Xóa thất bại. Vui lòng thử lại');
      }
    } catch (error) {
      print('Lỗi delete tuition fee: $error');
    }
  }

  Future<void> payTuitionFee({
    required String studentId,
    required String tuitionFeeId,
    required String soTienDong,
    required String paymentMethod,
    required Function(bool) onSuccess,
  }) async {
    try {
      isLoadingPay(true);

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'PUT',
        Uri.parse(
          'https://backend-shool-project.onrender.com/admin/pay_tuition_fee/$studentId/$tuitionFeeId',
        ),
      );
      request.body = json.encode({
        "soTienDong": soTienDong,
        "paymentMethod": paymentMethod,
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        isLoadingPay(false);
        onSuccess(true);
      } else {
        showFailStatus('Đóng học phí thất bại. Vui lòng thử lại');
        isLoadingPay(false);
      }
    } catch (error) {
      print('Lỗi pay tuition fee: $error');
      isLoadingPay(false);
    } finally {
      isLoadingPay(false);
    }
  }

  Future<void> feesHistoryStudent(String studentId) async {
    try {
      var response = await http.get(
        Uri.parse(
          'https://backend-shool-project.onrender.com/admin/payment_history/$studentId',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        feesHistory.assignAll(data.map((e) => FeesHistory.fromJson(e)).toList());
      } else {
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Lỗi get fees history: $error');
    }
  }

  void searchFees(String query) {
    if (query.isEmpty) {
      filteredFeesList.assignAll(feesList);
    } else {
      filteredFeesList
          .assignAll(feesList.where((fee) => fee.maTraCuu!.toLowerCase().contains(query.toLowerCase())).toList());
    }
  }

  Future<void> addTuitionFeeToStudent(
    String studentId, {
    required String tenHocPhi,
    required String noiDungHocPhi,
    required String soTienPhatHanh,
    required String soTienDong,
    required String hanDongTien,
  }) async {
    try {
      isLoadingAddFeesStudent(true);

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse(
          'https://backend-shool-project.onrender.com/admin/add_tuition_fee_to_student/$studentId',
        ),
      );
      request.body = json.encode({
        "tenHocPhi": tenHocPhi,
        "noiDungHocPhi": noiDungHocPhi,
        "soTienPhatHanh": soTienPhatHanh,
        "soTienDong": soTienDong,
        "hanDongTien": hanDongTien,
        "soTienNo": soTienDong,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        showSuccessStatus('Cập nhật thành công');

        Get.back();

        isLoadingAddFeesStudent(false);
      } else {
        showErrorStatus('Cập nhật thất bại. Vui lòng thử lại');
        isLoadingAddFeesStudent(false);
      }
    } catch (error) {
      print('Lỗi add tuition fee to student: $error');
      isLoadingAddFeesStudent(false);
    } finally {
      isLoadingAddFeesStudent(false);
    }
  }

  Future<void> updateTuitionFeeToStudent({
    required String studentId,
    required String tuitionFeeId,
    required String tenHocPhi,
    required String noiDungHocPhi,
    required String soTienPhatHanh,
    required String soTienDong,
    required String hanDongTien,
  }) async {
    try {
      isLodingUpdateFeeToStudent(true);

      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
        'PUT',
        Uri.parse(
          'https://backend-shool-project.onrender.com/admin/update_tuition_fee_to_student/$studentId/$tuitionFeeId',
        ),
      );
      request.body = json.encode({
        "tenHocPhi": tenHocPhi,
        "noiDungHocPhi": noiDungHocPhi,
        "soTienPhatHanh": soTienPhatHanh,
        "soTienDong": soTienDong,
        "hanDongTien": hanDongTien,
        "soTienNo": soTienDong,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        showSuccessStatus('Cập nhật thành công');

        Get.back();

        isLodingUpdateFeeToStudent(false);
      } else {
        showErrorStatus('Cập nhật thất bại. Vui lòng thử lại');
      }
    } catch (error) {
      print('Lỗi update fees to student: $error');
      isLodingUpdateFeeToStudent(false);
    } finally {
      isLodingUpdateFeeToStudent(false);
    }
  }

  Future<void> deleteTuitionFeeToStudent({
    required String studentId,
    required String tuitionFeeId,
    required String name,
  }) async {
    try {
      var response = await http.delete(
        Uri.parse(
          'https://backend-shool-project.onrender.com/admin/delete_tuition_fee_from_student/$studentId/$tuitionFeeId',
        ),
      );

      if (response.statusCode == 200) {
        showSuccessStatus('Xóa học phí $name thành công');
      } else {
        showFailStatus('Xóa thất bại, Vui lòng thử lại');
      }
    } catch (error) {
      print('Lỗi update fees to student: $error');
    }
  }
}
