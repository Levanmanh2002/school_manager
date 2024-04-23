import 'package:school_web/web/models/student.dart';

class Notifications {
  String? sId;
  String? title;
  String? message;
  String? systemIds;
  String? createdAt;
  int? iV;
  bool? isRead;
  String? classIds;
  String? uniformIds;
  String? majorIds;
  String? feesIds;
  Teacher? teacherId;
  Students? studentId;

  Notifications({
    this.sId,
    this.title,
    this.message,
    this.systemIds,
    this.createdAt,
    this.iV,
    this.isRead,
    this.classIds,
    this.uniformIds,
    this.majorIds,
    this.feesIds,
    this.teacherId,
    this.studentId,
  });

  Notifications.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    message = json['message'];
    systemIds = json['systemIds'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    isRead = json['isRead'];
    classIds = json['classIds'];
    uniformIds = json['uniformIds'];
    majorIds = json['majorIds'];
    feesIds = json['feesIds'];
    teacherId = json['teacherId'] != null ? Teacher.fromJson(json['teacherId']) : null;
    studentId = json['studentId'] != null ? Students.fromJson(json['studentId']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['title'] = title;
    data['message'] = message;
    data['systemIds'] = systemIds;
    data['createdAt'] = createdAt;
    data['__v'] = iV;
    data['isRead'] = isRead;
    data['classIds'] = classIds;
    data['uniformIds'] = uniformIds;
    data['majorIds'] = majorIds;
    data['feesIds'] = feesIds;
    if (teacherId != null) {
      data['teacherId'] = teacherId!.toJson();
    }
    if (studentId != null) {
      data['studentId'] = studentId!.toJson();
    }
    return data;
  }
}

class Teacher {
  String? sId;
  String? teacherId;
  String? fullName;
  String? teacherCode;
  String? email;
  String? password;
  String? phoneNumber;
  String? gender;
  String? cccd;
  String? birthDate;
  String? birthPlace;
  String? ethnicity;
  String? nickname;
  String? teachingLevel;
  String? position;
  String? experience;
  String? department;
  String? role;
  String? joinDate;
  bool? civilServant;
  String? contractType;
  String? primarySubject;
  String? secondarySubject;
  bool? isWorking;
  String? academicDegree;
  String? standardDegree;
  String? politicalTheory;
  String? avatarUrl;
  String? address;
  String? city;
  String? district;
  String? ward;
  int? system;
  int? iV;
  String? createdAt;
  String? updatedAt;

  Teacher({
    this.sId,
    this.teacherId,
    this.fullName,
    this.teacherCode,
    this.email,
    this.password,
    this.phoneNumber,
    this.gender,
    this.cccd,
    this.birthDate,
    this.birthPlace,
    this.ethnicity,
    this.nickname,
    this.teachingLevel,
    this.position,
    this.experience,
    this.department,
    this.role,
    this.joinDate,
    this.civilServant,
    this.contractType,
    this.primarySubject,
    this.secondarySubject,
    this.isWorking,
    this.academicDegree,
    this.standardDegree,
    this.politicalTheory,
    this.avatarUrl,
    this.address,
    this.city,
    this.district,
    this.ward,
    this.system,
    this.iV,
    this.createdAt,
    this.updatedAt,
  });

  Teacher.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    teacherId = json['teacherId'];
    fullName = json['fullName'];
    teacherCode = json['teacherCode'];
    email = json['email'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    gender = json['gender'];
    cccd = json['cccd'];
    birthDate = json['birthDate'];
    birthPlace = json['birthPlace'];
    ethnicity = json['ethnicity'];
    nickname = json['nickname'];
    teachingLevel = json['teachingLevel'];
    position = json['position'];
    experience = json['experience'];
    department = json['department'];
    role = json['role'];
    joinDate = json['joinDate'];
    civilServant = json['civilServant'];
    contractType = json['contractType'];
    primarySubject = json['primarySubject'];
    secondarySubject = json['secondarySubject'];
    isWorking = json['isWorking'];
    academicDegree = json['academicDegree'];
    standardDegree = json['standardDegree'];
    politicalTheory = json['politicalTheory'];
    avatarUrl = json['avatarUrl'];
    address = json['address'];
    city = json['city'];
    district = json['district'];
    ward = json['ward'];
    system = json['system'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['teacherId'] = teacherId;
    data['fullName'] = fullName;
    data['teacherCode'] = teacherCode;
    data['email'] = email;
    data['password'] = password;
    data['phoneNumber'] = phoneNumber;
    data['gender'] = gender;
    data['cccd'] = cccd;
    data['birthDate'] = birthDate;
    data['birthPlace'] = birthPlace;
    data['ethnicity'] = ethnicity;
    data['nickname'] = nickname;
    data['teachingLevel'] = teachingLevel;
    data['position'] = position;
    data['experience'] = experience;
    data['department'] = department;
    data['role'] = role;
    data['joinDate'] = joinDate;
    data['civilServant'] = civilServant;
    data['contractType'] = contractType;
    data['primarySubject'] = primarySubject;
    data['secondarySubject'] = secondarySubject;
    data['isWorking'] = isWorking;
    data['academicDegree'] = academicDegree;
    data['standardDegree'] = standardDegree = standardDegree;
    data['politicalTheory'] = politicalTheory;
    data['avatarUrl'] = avatarUrl;
    data['address'] = address;
    data['city'] = city;
    data['district'] = district;
    data['ward'] = ward;
    data['system'] = system;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
