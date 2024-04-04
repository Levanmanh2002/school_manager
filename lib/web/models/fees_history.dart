import 'package:school_web/web/models/fee.dart';

class FeesHistory {
  String? sId;
  StudentId? student;
  Fees? fees;
  int? amountPaid;
  String? paymentMethod;
  String? paymentDate;
  int? iV;

  FeesHistory({
    this.sId,
    this.student,
    this.fees,
    this.amountPaid,
    this.paymentMethod,
    this.paymentDate,
    this.iV,
  });

  FeesHistory.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    student = json['studentId'] != null ? StudentId.fromJson(json['studentId']) : null;
    fees = json['tuitionFeeId'] != null ? Fees.fromJson(json['tuitionFeeId']) : null;
    amountPaid = json['amountPaid'];
    paymentMethod = json['paymentMethod'];
    paymentDate = json['paymentDate'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (student != null) {
      data['studentId'] = student!.toJson();
    }
    if (fees != null) {
      data['tuitionFeeId'] = fees!.toJson();
    }
    data['amountPaid'] = amountPaid;
    data['paymentMethod'] = paymentMethod;
    data['paymentDate'] = paymentDate;
    data['__v'] = iV;
    return data;
  }
}

class StudentId {
  String? sId;
  String? studentId;
  String? mssv;
  String? fullName;
  String? gender;
  String? gmail;
  String? phone;
  String? birthDate;
  String? cccd;
  String? createdAt;
  String? updatedAt;
  int? iV;

  StudentId({
    this.sId,
    this.studentId,
    this.mssv,
    this.fullName,
    this.gender,
    this.gmail,
    this.phone,
    this.birthDate,
    this.cccd,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  StudentId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    studentId = json['studentId'];
    mssv = json['mssv'];
    fullName = json['fullName'];
    gender = json['gender'];
    gmail = json['gmail'];
    phone = json['phone'];
    birthDate = json['birthDate'];
    cccd = json['cccd'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['studentId'] = studentId;
    data['mssv'] = mssv;
    data['fullName'] = fullName;
    data['gender'] = gender;
    data['gmail'] = gmail;
    data['phone'] = phone;
    data['birthDate'] = birthDate;
    data['cccd'] = cccd;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
