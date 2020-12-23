
import 'package:universal_html/js.dart' as js;
import 'package:colorful_log/colorful_log.dart';
import 'package:flutter/foundation.dart';

class Logger {

  static const String _Default_Tag = "Logger";

  static bool _debuggable = kDebugMode; //是否是debug模式,true: log v 不输出.

  static js.JsObject _console = js.context['console'];
  static List _consoleColor = ['color:limegreen', 'color:white', 'color:limegreen', 'color:cornflowerblue', 'color:yellow', 'color:red'];

  static void d(String desc, {String tag, Object object}) {
    if (_debuggable) {
      _printLog(desc, tag, Log.debug, object);
    }
  }

  static void i(String desc, {String tag, Object object}){
    if(_debuggable) {
      _printLog(desc, tag, Log.info, object);
    }
  }

  static void w(String desc, {String tag, Object object}){
    if(_debuggable) {
      _printLog(desc, tag, Log.warn, object);
    }
  }

  static void e(String desc, {String tag, Object object}) {
    _printLog(desc, tag, Log.error, object);
  }


  static void _printLog(String desc, String tag, int level, Object object) {
    String t = (tag != null && tag.isNotEmpty)?'$tag -->> ':'$_Default_Tag -->> ';
    if(_console != null) {
      _console.callMethod('log', ['%c$t$desc', _consoleColor[level], (object??'')]);
    }
    else {
      StringBuffer sb = StringBuffer()
        ..write(t)
        ..write(object);

      switch(level) {
        case 1: Log.V(tag, sb.toString()); break;
        case 2: Log.I(tag, sb.toString()); break;
        case 3: Log.D(tag, sb.toString()); break;
        case 4: Log.W(tag, sb.toString()); break;
        case 5: Log.E(tag, sb.toString()); break;
      }
    }
  }
}
