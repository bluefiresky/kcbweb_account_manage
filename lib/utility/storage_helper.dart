

import 'package:universal_html/html.dart' as html;


class StorageHelper {
  static html.Storage _localStorage = html.window?.localStorage;
  static html.Storage _sessionStorage = html.window?.sessionStorage;

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


  static void sessionSave(String key, String value){
    if(_sessionStorage != null) {
      _sessionStorage[key] = value;
    }
  }

  static String sessionGet(String key){
    if(_sessionStorage != null) {
      return _sessionStorage[key];
    }
    else return null;
  }

  static List sessionAll(){
    if(_sessionStorage != null) {
      return _sessionStorage.entries.toList();
    }
    else {
      return [];
    }
  }

}