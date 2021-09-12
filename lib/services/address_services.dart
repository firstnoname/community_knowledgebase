import 'dart:convert';

import 'package:community_knowledgebase/models/models.dart';
import 'package:flutter/services.dart' show rootBundle;

class AddressServices {
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
              type: 'Province'),
        );
      } else {
        i--;
      }
    }
    _provices.sort((a, b) => a.name.compareTo(b.name));
    return _provices;
  }
}
