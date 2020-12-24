

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class XIndicator {

  static void loading(Function complete){
    EasyLoading.instance
      ..indicatorSize = 49
      ..indicatorType = EasyLoadingIndicatorType.dualRing
      ..maskColor = Colors.black.withOpacity(0.3)
      ..maskType = EasyLoadingMaskType.custom
      ..dismissOnTap = false
    ;
    EasyLoading.show(status: 'loading...');
    complete((){ EasyLoading.dismiss(); });
  }
}