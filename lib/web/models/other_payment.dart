class OtherPayment {
  String? sId;
  String? name;
  String? description;
  String? address;
  double? price;
  int? iV;
  String? createdAt;
  String? updatedAt;

  OtherPayment({
    this.sId,
    this.name,
    this.description,
    this.address,
    this.price,
    this.iV,
    this.createdAt,
    this.updatedAt,
  });

  OtherPayment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    address = json['address'];
    price = json['price'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['description'] = description;
    data['address'] = address;
    data['price'] = price;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
