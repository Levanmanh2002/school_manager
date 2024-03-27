import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/models/teacher.dart';

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
  TeacherData? teacherId;
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
    teacherId = json['teacherId'] != null ? TeacherData.fromJson(json['teacherId']) : null;
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
