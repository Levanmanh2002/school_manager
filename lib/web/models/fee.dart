class Fee {
  String? sId;
  String? name;
  List<SubFees>? subFees;
  int? iV;

  Fee({this.sId, this.name, this.subFees, this.iV});

  Fee.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    if (json['subFees'] != null) {
      subFees = <SubFees>[];
      json['subFees'].forEach((v) {
        subFees!.add(SubFees.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    if (subFees != null) {
      data['subFees'] = subFees!.map((v) => v.toJson()).toList();
    }
    data['__v'] = iV;
    return data;
  }
}

class SubFees {
  String? searchCode;
  String? content;
  int? issuedAmount;
  int? paidAmount;
  int? remainingAmount;
  int? debtAmount;
  String? dueDate;
  String? sId;
  String? createdAt;
  String? updatedAt;

  SubFees({
    this.searchCode,
    this.content,
    this.issuedAmount,
    this.paidAmount,
    this.remainingAmount,
    this.debtAmount,
    this.dueDate,
    this.sId,
    this.createdAt,
    this.updatedAt,
  });

  SubFees.fromJson(Map<String, dynamic> json) {
    searchCode = json['searchCode'];
    content = json['content'];
    issuedAmount = json['issuedAmount'];
    paidAmount = json['paidAmount'];
    remainingAmount = json['remainingAmount'];
    debtAmount = json['debtAmount'];
    dueDate = json['dueDate'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['searchCode'] = searchCode;
    data['content'] = content;
    data['issuedAmount'] = issuedAmount;
    data['paidAmount'] = paidAmount;
    data['remainingAmount'] = remainingAmount;
    data['debtAmount'] = debtAmount;
    data['dueDate'] = dueDate;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
