import 'package:community_knowledgebase/models/address/base_address.dart';

class Address {
  BaseAddress? province;
  BaseAddress? district;
  BaseAddress? subDistrict;

  Address({
    this.province,
    this.district,
    this.subDistrict,
  });

  factory Address.fromJson(dynamic json) => Address(
        province: json['provice'] != null
            ? BaseAddress.fromJson(json['province'])
            : null,
        district: json['district'] != null
            ? BaseAddress.fromJson(json['district'])
            : null,
        subDistrict: json['sub_district'] != null
            ? BaseAddress.fromJson(json['sub_district'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'provice': province != null ? province!.toJson() : null,
        'district': district != null ? district!.toJson() : null,
        'sub_district': subDistrict != null ? subDistrict!.toJson() : null,
      };
}
