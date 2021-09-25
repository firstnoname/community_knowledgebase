class BaseAddress {
  String? id;
  String? name;
  String? provinceId;

  BaseAddress({
    this.id,
    this.name,
    this.provinceId,
  });

  factory BaseAddress.fromJson(dynamic json) => BaseAddress(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      provinceId: json['province_id'] ?? '');

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'province_id': provinceId,
      };
}
