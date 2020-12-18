
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:kcbweb_account_manage/common/tip_helper.dart';
import 'package:kcbweb_account_manage/data_models/remote_data.dart';
import 'package:kcbweb_account_manage/remote/fetch_config.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';


class FetchFactory {

  static Map<String, String> headers = { 'token':'', 'Content-type':'application/json', 'pikav':'2.3.10' };

  /// Action
  static RemoteData generateResData(http.Response response){
    if(response == null)  {
      TipHelper.toast(msg:'网络连接异常，请稍后重试');
      return null;
    }
    else {
      try {
        if(response.statusCode == 200) {
          var jsonRes = convert.jsonDecode(response.body);
          int errorCode = jsonRes['statusCode'];
          if(errorCode == 200) {
            return RemoteData(errorCode, jsonRes['message'], jsonRes['data']);
          }
          else {
            String message = jsonRes['message'];
            if(message != null && message.isNotEmpty) TipHelper.toast(msg: message);
            else TipHelper.toast(msg: '数据获取异常，请稍后重试');
            return null;
          }
        }else {
          TipHelper.toast(msg:'网络连接异常，请稍后重试');
          return null;
        }
      }catch(exception){
        LogHelper.v('000000 generateResData -->> $exception');
        return null;
      }
    }
  }

  static _generatePath(String path, String version){
    if(version != null && version.isNotEmpty) return '$SERVICE_URL/api/$version/app/$path';
    return '$SERVICE_URL$API_PRE$path';
  }

  /// Method Factory
  static get (String url, { String version, Map params }) async {
    String path = _generatePath(url, version);
    if(params != null && params.isNotEmpty) {
      StringBuffer sb = new StringBuffer('?');
      params.forEach((key, value) { sb.write('$key=$value&'); });
      String paramStr = sb.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      path += paramStr;
    }

    LogHelper.v('000000 GET path -->> $path');

    try {
      http.Response response = await http.get(path, headers: headers);
      return generateResData(response);
    }catch (exception){
      LogHelper.e('000000 GET exception -->> $exception');
      return generateResData(null);
    }
  }

  static post (String url, { String version, Map params}) async {
    String path = _generatePath(url, version);

    LogHelper.v('000000 POST path -->> $path');
    
    try{
      var body = (params != null && params.isNotEmpty)? convert.jsonEncode(params) : convert.jsonEncode({});
      http.Response response = await http.post(path, headers: headers, body:body);
      return generateResData(response);
    }catch(exception){
      LogHelper.e('000000 POST exception -->> $exception');
      return generateResData(null);
    }
  }

}