import 'package:school_web/web/models/student.dart';
import 'package:school_web/web/models/teacher.dart';

class ClassInfoData {
  String? className;
  String? id;
	String? idClass;
  int? numberOfStudents;
  List<TeacherData>? teacher;
  List<StudentData>? students;

  ClassInfoData({this.className, this.numberOfStudents, this.teacher, this.students});

  ClassInfoData.fromJson(Map<String, dynamic> json) {
    className = json['className'];
    id = json['id'];
		idClass = json['idClass'];
    numberOfStudents = json['numberOfStudents'];

    if (json['teacher'] != null) {
      teacher = <TeacherData>[];
      if (json['teacher'] is List) {
        for (var v in (json['teacher'] as List)) {
          if (v is Map<String, dynamic>) {
            teacher!.add(TeacherData.fromJson(v));
          }
        }
      }
    }

    if (json['students'] != null) {
      students = <StudentData>[];
      if (json['students'] is List) {
        for (var v in (json['students'] as List)) {
          if (v is Map<String, dynamic>) {
            students!.add(StudentData.fromJson(v));
          }
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['className'] = className;
    data['id'] = id;
		data['idClass'] = idClass;
    data['numberOfStudents'] = numberOfStudents;
    if (teacher != null) {
      data['teacher'] = teacher!.map((v) => v.toJson()).toList();
    }
    if (students != null) {
      data['students'] = students!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Classes {
  String? className;
  String? id;

  Classes({this.className, this.id});

  Classes.fromJson(Map<String, dynamic> json) {
    className = json['className'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['className'] = className;
    data['id'] = id;
    return data;
  }
}
