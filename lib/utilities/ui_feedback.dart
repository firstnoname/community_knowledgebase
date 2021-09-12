import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UIFeedback {
  final BuildContext _context;

  UIFeedback(this._context);

  Future showLoading() {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..dismissOnTap = false
      ..indicatorType = EasyLoadingIndicatorType.circle;
    return EasyLoading.show(status: "Loading...");
  }

  Future hideLoading() {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    return Future.delayed(const Duration(microseconds: 1));
  }
}
