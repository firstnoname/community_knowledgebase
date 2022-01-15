import 'dart:typed_data';

import 'package:community_knowledgebase/utilities/ui_feedback.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

class ImageSelection {
  Future<List<Uint8List>> getMultiImagesBytes(BuildContext context) async {
    List<Uint8List> fromPicker =
        (await ImagePickerWeb.getMultiImages(outputType: ImageType.bytes) ?? [])
            as List<Uint8List>;

    if (fromPicker.isNotEmpty) {
      if (fromPicker.length > 10) {
        fromPicker = [];
        UIFeedback(context).showErrorDialog(context,
            title: 'เกิดข้อผิดพลาด',
            content: 'ท่านเลือกรูปจำนวนมากเกินไป, เลือกรูปภาพไม่เกิน 10 รูป');
      }
    }

    return fromPicker.map((e) => e).toList();
  }
}
