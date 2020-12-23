

import 'package:universal_html/html.dart' as html;


class StorageHelper {
  static html.Storage _localStorage = html.window?.localStorage;

  static const String authKey = 'auth_key';


  static void save(String key, String value){
    if(_localStorage != null) {
      _localStorage[key] = value;
    }
  }

  static String get(String key) {
    if(_localStorage != null) {
      return _localStorage[key];
    }
    else return null;
  }

  static List getAll(){
    if(_localStorage != null) {
      return _localStorage.entries.toList();
    }
    else {
      return [];
    }
  }

}