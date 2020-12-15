
import 'package:flutter/foundation.dart';

class LogHelper {

  static const String _Default_Tag = "### log_helper ###";

  static bool _debuggable = kDebugMode; //是否是debug模式,true: log v 不输出.
  static String _TAG = _Default_Tag;

  static void e(Object object, {String tag}) {
    _printLog(tag, '  e  ', object);
  }

  static void v(Object object, {String tag}) {
    if (_debuggable) {
      _printLog(tag, '  v  ', object);
    }
  }

  static void _printLog(String tag, String stag, Object object) {
    StringBuffer sb = new StringBuffer();
    sb.write(stag);
    sb.write((tag == null || tag.isEmpty) ? _TAG : tag);
    sb.write(object);
    print(sb.toString());
  }
}
