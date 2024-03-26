class Fees {
  String? sId;
  String? maTraCuu;
  String? tenHocPhi;
  String? noiDungHocPhi;
  int? soTienPhatHanh;
  int? soTienDong;
  int? soTienNo;
  bool? status;
  String? hanDongTien;
  int? iV;
  String? createdAt;
  String? updatedAt;

  Fees({
    this.sId,
    this.maTraCuu,
    this.tenHocPhi,
    this.noiDungHocPhi,
    this.soTienPhatHanh,
    this.soTienDong,
    this.soTienNo,
    this.status,
    this.hanDongTien,
    this.iV,
    this.createdAt,
    this.updatedAt,
  });

  Fees.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    maTraCuu = json['maTraCuu'];
    tenHocPhi = json['tenHocPhi'];
    noiDungHocPhi = json['noiDungHocPhi'];
    soTienPhatHanh = json['soTienPhatHanh'];
    soTienDong = json['soTienDong'];
    soTienNo = json['soTienNo'];
    status = json['status'];
    hanDongTien = json['hanDongTien'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['maTraCuu'] = maTraCuu;
    data['tenHocPhi'] = tenHocPhi;
    data['noiDungHocPhi'] = noiDungHocPhi;
    data['soTienPhatHanh'] = soTienPhatHanh;
    data['soTienDong'] = soTienDong;
    data['soTienNo'] = soTienNo;
    data['status'] = status;
    data['hanDongTien'] = hanDongTien;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
