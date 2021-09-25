import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_knowledgebase/models/models.dart';
import 'package:flutter/services.dart' show rootBundle;

class AddressServices {
  static const collectionSubDistrict = 'subdistricts';
  // เกิดปัญหาตอนพยายาม decode json. ต้องย้ายไปดึงจาก firebase ก่อน
  Future<List<BaseAddress>> getProvices() async {
    List<BaseAddress> _provices = [];
    var jsonProvinces = await rootBundle.loadString('assets/json/test.json');
    Map<String, dynamic> decodeChangwatJson = json.decode(jsonProvinces);

    for (int i = 0; i < decodeChangwatJson.length; i++) {
      var valueProvinces = decodeChangwatJson['$i']['name'];
      if (valueProvinces != null) {
        _provices.add(
          BaseAddress(
              id: decodeChangwatJson['name'],
              name: valueProvinces['name']['th'] ?? null,
              provinceId: 'province'),
        );
      } else {
        i--;
      }
    }
    _provices.sort((a, b) => a.name!.compareTo(b.name!));
    return _provices;
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
}
