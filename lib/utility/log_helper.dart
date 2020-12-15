
import 'package:flutter/foundation.dart';

class LogHelper {

  static const String _Default_Tag = "### log_helper ###";

  static bool debuggable = kDebugMode; //是否是debug模式,true: log v 不输出.
  static String TAG = _Default_Tag;

  static void init({bool isDebug = false, String tag = _Default_Tag}) {
    print("1111111111 -->> $debuggable" );
    debuggable = isDebug;
    TAG = tag;
  }

  static void e(Object object, {String tag}) {
    _printLog(tag, '  e  ', object);
  }

  static void v(Object object, {String tag}) {
    if (debuggable) {
      _printLog(tag, '  v  ', object);
    }
  }

  static void _printLog(String tag, String stag, Object object) {
    StringBuffer sb = new StringBuffer();
    sb.write(stag);
    sb.write((tag == null || tag.isEmpty) ? TAG : tag);
    sb.write(object);
    print(sb.toString());
  }
}
