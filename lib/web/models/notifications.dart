import 'package:school_web/web/models/teacher.dart';

class Notifications {
  String? sId;
  TeacherData? teacherId;
  String? message;
  String? createdAt;
  int? iV;

  Notifications({
    this.sId,
    this.teacherId,
    this.message,
    this.createdAt,
    this.iV,
  });

  Notifications.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    teacherId = json['teacherId'] != null ? TeacherData.fromJson(json['teacherId']) : null;
    message = json['message'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (teacherId != null) {
      data['teacherId'] = teacherId!.toJson();
    }
    data['message'] = message;
    data['createdAt'] = createdAt;
    data['__v'] = iV;
    return data;
  }
}
