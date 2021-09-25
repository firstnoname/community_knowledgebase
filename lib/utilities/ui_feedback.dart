import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UIFeedback {
  final BuildContext _context;
  bool isShowingDialog = false;

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

  Future<void> showErrorDialog(BuildContext context,
      {String title = '', String content = ''}) {
    return showOKDialog(context, title, content);
  }

  Future<void> showOKDialog(
      BuildContext context, String title, String content) {
    isShowingDialog = true;
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
