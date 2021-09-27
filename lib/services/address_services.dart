import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

class AddressServices {
  static const collectionSubDistrict = 'subdistricts';
  // เกิดปัญหาตอนพยายาม decode json. ต้องย้ายไปดึงจาก firebase ก่อน
  Future<List<BaseAddress>> getProvices() async {
    List<BaseAddress> _provices = [];
    var jsonProvinces =
        await rootBundle.loadString('assets/json/changwats.json');
    Map<String, dynamic> decodeChangwatJson = json.decode(jsonProvinces);

    for (int i = 10; i < decodeChangwatJson.length; i++) {
      if (decodeChangwatJson['$i'] != null) {
        Map<String, dynamic> valueProvinces = decodeChangwatJson['$i'];
        if (valueProvinces.isNotEmpty) {
          var valueProvinceInside = valueProvinces['name'];

          _provices.add(
            BaseAddress(
                id: i.toString(),
                name: valueProvinceInside['th'] ?? '',
                provinceId: '$i'),
          );
        } else {
          i--;
        }
      }
    }
    _provices.sort((a, b) => a.name!.compareTo(b.name!));
    return _provices;
  }

  Future<List<BaseAddress>> getDistricts({required String provinceId}) async {
    print('province id -> $provinceId');
    List<BaseAddress> _districts = [];
    var jsonDistricts = await rootBundle.loadString('assets/json/amphoes.json');
    Map<String, dynamic> decodeDistrictJson = json.decode(jsonDistricts);
    int key = int.parse('${provinceId}01');
    for (int i = 0; i < decodeDistrictJson.length; i++) {
      if (decodeDistrictJson['$key'] != null) {
        Map<String, dynamic> valueDistricts = decodeDistrictJson['$key'];
        if (valueDistricts.isNotEmpty) {
          var valueDistrictInside = valueDistricts['name'];
          if (valueDistricts['changwat_id'] == provinceId) {
            print('district item -> ${valueDistricts['changwat_id']}');
            _districts.add(
              BaseAddress(
                  id: key.toString(),
                  name: valueDistrictInside['th'] ?? '',
                  provinceId: '$provinceId'),
            );
          }
        } else {
          // i--;
        }
      }
      key++;
    }
    _districts.sort((a, b) => a.name!.compareTo(b.name!));

    return _districts;
  }

  Future<List<BaseAddress>> getSubDistrict(String? districtId) async {
    var jsonSubDistrict =
        await rootBundle.loadString('assets/json/tambons.json');
    Map<String, dynamic> decodeSubDistrictJson = json.decode(jsonSubDistrict);
    List<BaseAddress> _subDistricts = [];
    int key = int.parse('${districtId}01');

    for (int i = 0; i < decodeSubDistrictJson.length; i++) {
      if (decodeSubDistrictJson['$key'] != null) {
        Map<String, dynamic> valueInside = decodeSubDistrictJson['$key'];
        var jsonSubDistrictId = valueInside["amphoe_id"];
        if (jsonSubDistrictId == districtId) {
          print('subdistrict -> ${valueInside['name']['th']}');
          // _subDistricts.add(
          //   BaseAddress(
          //       id: key.toString(),
          //       name: valueInside['name']['th'] ?? '',
          //       provinceId: '${valueInside['changwat_id']}'),
          // );
        }
      } else {
        i--;
      }
      key++;
    }
    _subDistricts.sort((a, b) => a.name!.compareTo(b.name!));
    return _subDistricts;
  }

  Future<List<BaseAddress>> getSubDistricts() async {
    var subDistricts = <BaseAddress>[];

    try {
      var result = await FirebaseFirestore.instance
          .collection(collectionSubDistrict)
          .get();

      if (result.docs.isNotEmpty)
        subDistricts = result.docs
            .map((item) =>
                BaseAddress.fromJson(item.data()..addAll({'id': item.id})))
            .toList();
    } on Exception catch (e) {
      print('Get sub-district failed -> ${e.toString()}');
    }

    return subDistricts;
  }

  // Call api Thaikub to get Province.
  String baseAPIUrl = 'https://thaiaddressapi-thaikub.herokuapp.com';
  Future<List<BaseAddress>> getProvinceAPI() async {
    String getProvince = '/v1/thailand/provinces';
    String apiURL = baseAPIUrl + getProvince;

    List<BaseAddress> provinces = [];

    var response = await Dio().get(apiURL);
    List data = response.data['data'];
    print('response first province -> ${data[0]['province']}');
    provinces = data
        .map((province) => BaseAddress(name: province['province']))
        .toList();

    return provinces;
  }

  Future<List<BaseAddress>> getDistrictAPI(String provinceName) async {
    String getDistrict = '/v1/thailand/provinces/$provinceName/district';
    String apiURL = baseAPIUrl + getDistrict;

    List<BaseAddress> districts = [];

    var response = await Dio().get(apiURL);
    List data = response.data['data'];
    print('response first district -> ${data[0]}');
    districts = data.map((district) => BaseAddress(name: district)).toList();

    return districts;
  }

  Future<List<BaseAddress>> getSubDistrictAPI(
      String provinceName, String districtName) async {
    String getSubDistrict =
        '/v1/thailand/provinces/$provinceName/district/$districtName';
    String apiURL = baseAPIUrl + getSubDistrict;

    List<BaseAddress> subDistricts = [];

    var response = await Dio().get(apiURL);
    List data = response.data['data'];
    print('response first subdistrict -> ${data[0]}');
    subDistricts =
        data.map((subDistrict) => BaseAddress(name: subDistrict)).toList();

    return subDistricts;
  }
}
