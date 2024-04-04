// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/services.dart';

class NumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Xóa bỏ tất cả các ký tự không phải số
    var newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    // Định dạng số với dấu phẩy sau mỗi 3 chữ số
    final regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    newText = newText.replaceAllMapped(regExp, (match) => '${match[1]}.');

    // Trả về giá trị mới của TextFormField
    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
