
import 'package:colorful_log/colorful_log.dart';
import 'package:flutter/foundation.dart';

class Logger {

  static const String _Default_Tag = "Logger -- ";

  static bool _debuggable = kDebugMode; //是否是debug模式,true: log v 不输出.


  static void d(Object object, {String tag}) {
    if (_debuggable) {
      _printLog(tag, Log.debug, object);
    }
  }

  static void i(Object object, {String tag}){
    if(_debuggable) {
      _printLog(tag, Log.info, object);
    }
  }

  static void w(Object object, {String tag}){
    if(_debuggable) {
      _printLog(tag, Log.warn, object);
    }
  }

  static void e(Object object, {String tag}) {
    _printLog(tag, Log.error, object);
  }


  static void _printLog(String tag, int level, Object object) {
    StringBuffer sb = StringBuffer()
      ..write((tag == null || tag.isEmpty) ? _Default_Tag : tag)
      ..write(object);

    switch(level) {
      case 1: Log.V(tag, sb.toString()); break;
      case 2: Log.I(tag, sb.toString()); break;
      case 3: Log.D(tag, sb.toString()); break;
      case 4: Log.W(tag, sb.toString()); break;
      case 5: Log.E(tag, sb.toString()); break;
    }
    // print(sb.toString());
  }
}
