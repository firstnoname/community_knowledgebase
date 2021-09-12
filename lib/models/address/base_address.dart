class BaseAddress {
  String id;
  String name;
  String type;

  BaseAddress({
    required this.id,
    required this.name,
    required this.type,
  });

  factory BaseAddress.fromJson(dynamic json) => BaseAddress(
      id: json['id'] ?? '', name: json['name'] ?? '', type: json['type'] ?? '');

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
      };
}
