class Other {
  String? sId;
  String? name;
  String? money;
  String? quantity;
  String? note;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? image;

  Other({
    this.sId,
    this.name,
    this.money,
    this.quantity,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.iV,
    this.image,
  });

  Other.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    money = json['money'];
    quantity = json['quantity'];
    note = json['note'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['money'] = money;
    data['quantity'] = quantity;
    data['note'] = note;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['image'] = image;
    return data;
  }
}
