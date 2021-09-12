import 'package:community_knowledgebase/models/address/base_address.dart';

class Address {
  BaseAddress province;
  BaseAddress district;
  BaseAddress subDistrict;

  Address({
    required this.province,
    required this.district,
    required this.subDistrict,
  });

  factory Address.fromJson(dynamic json) => Address(
        province: json['provice'],
        district: json['district'],
        subDistrict: json['sub_district'],
      );

  Map<String, dynamic> toJson() => {
        'provice': province,
        'district': district,
        'sub_district': subDistrict,
      };
}
