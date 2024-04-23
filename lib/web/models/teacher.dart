class Teacher {
  String? status;
  String? message;
  int? total;
  TeacherData? data;
  String? token;

  Teacher({this.status, this.message, this.total, this.data, this.token});

  Teacher.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    total = json['total'];
    data = json['data'] != null ? TeacherData.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['total'] = total;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = token;
    return data;
  }
}

class TeacherData {
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
  String? ethnicity;
  String? experience;
  String? joinDate;
  bool? isWorking;
  String? avatarUrl;
  String? backgroundImageUrl;
  String? address;
  String? city;
  String? district;
  String? ward;
  int? system;
  GrantedBy? grantedBy;
  String? academicDegree;
  String? position;
  String? contractType;
  int? iV;
  String? createdAt;
  String? updatedAt;

  TeacherData({
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
    this.ethnicity,
    this.experience,
    this.joinDate,
    this.isWorking,
    this.avatarUrl,
    this.backgroundImageUrl,
    this.address,
    this.city,
    this.district,
    this.ward,
    this.system,
    this.grantedBy,
    this.academicDegree,
    this.position,
    this.contractType,
    this.iV,
    this.createdAt,
    this.updatedAt,
  });

  TeacherData.fromJson(Map<String, dynamic> json) {
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
    ethnicity = json['ethnicity'];
    experience = json['experience'];
    joinDate = json['joinDate'];
    isWorking = json['isWorking'];
    avatarUrl = json['avatarUrl'];
    backgroundImageUrl = json['backgroundImageUrl'];
    address = json['address'];
    city = json['city'];
    district = json['district'];
    ward = json['ward'];
    system = json['system'];
    grantedBy = json['grantedBy'] != null ? GrantedBy.fromJson(json['grantedBy']) : null;
    academicDegree = json['academicDegree'];
    position = json['position'];
    contractType = json['contractType'];

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
    data['ethnicity'] = ethnicity;
    data['experience'] = experience;
    data['joinDate'] = joinDate;
    data['isWorking'] = isWorking;
    data['avatarUrl'] = avatarUrl;
    data['backgroundImageUrl'] = backgroundImageUrl;
    data['address'] = address;
    data['city'] = city;
    data['district'] = district;
    data['ward'] = ward;
    data['system'] = system;
    if (grantedBy != null) {
      data['grantedBy'] = grantedBy!.toJson();
    }
    data['academicDegree'] = academicDegree;
    data['position'] = position;
    data['contractType'] = contractType;

    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class GrantedBy {
  int? system;
  String? sId;
  String? teacherId;
  String? fullName;
  String? teacherCode;
  String? email;
  String? phoneNumber;
  String? cccd;
  String? grantedBy;

  GrantedBy({
    this.system,
    this.sId,
    this.teacherId,
    this.fullName,
    this.teacherCode,
    this.email,
    this.phoneNumber,
    this.cccd,
    this.grantedBy,
  });

  GrantedBy.fromJson(Map<String, dynamic> json) {
    system = json['system'];
    sId = json['_id'];
    teacherId = json['teacherId'];
    fullName = json['fullName'];
    teacherCode = json['teacherCode'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    cccd = json['cccd'];
    grantedBy = json['grantedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['system'] = system;
    data['_id'] = sId;
    data['teacherId'] = teacherId;
    data['fullName'] = fullName;
    data['teacherCode'] = teacherCode;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['cccd'] = cccd;
    data['grantedBy'] = grantedBy;
    return data;
  }
}
