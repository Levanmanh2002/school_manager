import 'package:school_web/web/models/fee.dart';
import 'package:school_web/web/models/majors_models.dart';

class Students {
  String? sId;
  String? studentId;
  String? mssv;
  String? fullName;
  String? gender;
  String? gmail;
  String? phone;
  String? birthDate;
  String? cccd;
  String? customYear;
  String? password;
  String? ethnicity;
  String? beneficiary;
  String? fatherFullName;
  String? motherFullName;
  String? contactPhone;
  String? contactAddress;
  String? notes;
  String? address;
  String? city;
  String? district;
  String? ward;
  int? status;
  String? classStudent;
  String? avatarUrl;
  bool? isStudying;
  List<String>? graduationCertificate;
  List<Students>? students;
  MajorsData? major;
  String? createdAt;
  String? updatedAt;
  int? iV;
  List<Fees>? feesToPay;

  Students({
    this.sId,
    this.studentId,
    this.mssv,
    this.fullName,
    this.gender,
    this.gmail,
    this.phone,
    this.birthDate,
    this.cccd,
    this.customYear,
    this.password,
    this.ethnicity,
    this.beneficiary,
    this.students,
    this.graduationCertificate,
    this.fatherFullName,
    this.motherFullName,
    this.contactPhone,
    this.contactAddress,
    this.notes,
    this.address,
    this.city,
    this.district,
    this.ward,
    this.feesToPay,
    this.major,
    this.isStudying,
    this.status,
    this.classStudent,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Students.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    studentId = json['studentId'];
    mssv = json['mssv'];
    fullName = json['fullName'];
    gender = json['gender'];
    gmail = json['gmail'];
    phone = json['phone'];
    birthDate = json['birthDate'];
    cccd = json['cccd'];
    customYear = json['customYear'];
    password = json['password'];
    ethnicity = json['ethnicity'];
    beneficiary = json['beneficiary'];
    fatherFullName = json['fatherFullName'];
    motherFullName = json['motherFullName'];
    contactPhone = json['contactPhone'];
    contactAddress = json['contactAddress'];
    notes = json['notes'];
    address = json['address'];
    city = json['city'];
    district = json['district'];
    ward = json['ward'];
    status = json['status'];
    classStudent = json['class'];
    avatarUrl = json['avatarUrl'];
    isStudying = json['isStudying'];
    major = json['major'] != null ? MajorsData.fromJson(json['major']) : null;
    if (json['students'] != null) {
      students = (json['students'] as List).map((studentJson) {
        return Students.fromJson(studentJson);
      }).toList();
    }
    graduationCertificate = json['graduationCertificate'].cast<String>();
    if (json['feesToPay'] != null) {
      feesToPay = (json['feesToPay'] as List).map((feesJson) {
        return Fees.fromJson(feesJson);
      }).toList();
    }
    // if (json['feesToPay'] != null) {
    //   feesToPay = json['feesToPay'].map((feesItem) {
    //     return Fees.fromJson(feesItem);
    //   }).toList();
    // }
    // if (json['feesToPay'] != null) {
    //   final feesJson = json['feesToPay'];
    //   if (feesJson is List) {
    //     feesToPay = feesJson.map((feesItem) {
    //       return Fees.fromJson(feesItem);
    //     }).toList();
    //   } else if (feesJson is Map<String, dynamic>) {
    //     feesToPay = [Fees.fromJson(feesJson)];
    //   }
    // }
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
    data['customYear'] = customYear;
    data['password'] = password;
    data['ethnicity'] = ethnicity;
    data['beneficiary'] = beneficiary;
    data['fatherFullName'] = fatherFullName;
    data['motherFullName'] = motherFullName;
    data['contactPhone'] = contactPhone;
    data['contactAddress'] = contactAddress;
    data['notes'] = notes;
    data['address'] = address;
    data['city'] = city;
    data['district'] = district;
    data['ward'] = ward;
    data['isStudying'] = isStudying;
    data['status'] = status;
    if (major != null) {
      data['major'] = major!.toJson();
    }
    data['class'] = classStudent;
    if (students != null) {
      data['students'] = students!.map((v) => v.toJson()).toList();
    }
    data['graduationCertificate'] = graduationCertificate;
    data['avatarUrl'] = avatarUrl;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    if (feesToPay != null) {
      data['feesToPay'] = feesToPay!.map((v) => v.toJson()).toList();
    }
    // if (feesToPay != null) {
    //   if (feesToPay is List) {
    //     data['feesToPay'] = feesToPay?.map((v) => v.toJson()).toList();
    //   } else if (feesToPay is Map<String, dynamic>) {
    //     data['feesToPay'] = feesToPay;
    //   } else if (feesToPay is String) {}
    // }

    return data;
  }
}
