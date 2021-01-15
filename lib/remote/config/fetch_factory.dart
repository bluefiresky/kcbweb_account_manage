
import 'dart:convert' as convert;
import 'dart:developer' as developer;
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:kcbweb_account_manage/common/tip_helper.dart';
import 'package:kcbweb_account_manage/data_models/remote/remote_data.dart';
import 'package:kcbweb_account_manage/remote/config/fetch_config.dart';
import 'package:kcbweb_account_manage/remote/model/api-helper.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';


class FetchFactory {

  static const String TAG = "Remoter -- ";
  static Map<String, String> headers = { 'token':'', 'Content-type':'application/json', 'pikav':'2.3.10' };

  /// Action
  static RemoteData generateResData(http.Response response, String path, Map params){
    if(response == null)  {
      Logger.e('\n  path -->> $path \n  params -->> ${convert.jsonEncode(params)}', tag: '${TAG}request');
      Tipper.toast(msg:'网络连接异常，请稍后重试');
      return null;
    }
    else {
      try {
        if(response.statusCode == 200) {
          var jsonRes = convert.jsonDecode(response.body);
          int resStatusCode = jsonRes['statusCode'];

          if(resStatusCode == 200) {
            Logger.i('\n  statusCode -->> $resStatusCode \n  path -->> $path \n  params -->> ${convert.jsonEncode(params)} \n  res -->> ', object: jsonRes, tag: '${TAG}response');
            return RemoteData(resStatusCode, jsonRes['message'], jsonRes['data']);
          }
          else {
            String tip;
            String message = jsonRes['message'];
            tip = (message?.isNotEmpty ?? false)? message : '数据获取异常，请稍后重试';
            Tipper.toast(msg: tip);

            Logger.e('\n  statusCode -->> $resStatusCode -- message -->> $tip \n  path -->> $path \n  params -->> ${convert.jsonEncode(params)}', tag: '${TAG}response');
            return null;
          }
        }else {
          Logger.e('\n  http statusCode -->> ${response.statusCode}', tag: '${TAG}response');
          Tipper.toast(msg:'网络连接异常，请稍后重试');
          return null;
        }
      }catch(exception){
        Logger.e('\n  generateResData error -->>', object: exception, tag: '${TAG}response');
        return null;
      }
    }
  }

  static _generatePath(String path, String version){
    String url;

    if(version?.isNotEmpty ?? false) url = '$SERVICE_URL/api/$version/app/$path';
    else url = '$SERVICE_URL$API_PRE$path';

    return url;
  }

  /// Method Factory
  static get (String url, { String version, Map params }) async {
    String path = _generatePath(url, version);
    if(params?.isNotEmpty ?? false) {
      StringBuffer sb = new StringBuffer('?');
      params.forEach((key, value) { sb.write('$key=$value&'); });
      String paramStr = sb.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      path += paramStr;
    }

    try {
      http.Response response = await http.get(path, headers: headers);
      return generateResData(response, path, params);
    }catch (exception){
      return generateResData(null, null, params);
    }
  }

  static post (String url, { String version, Map params}) async {
    String path = _generatePath(url, version);


    try{
      var body = (params?.isNotEmpty ?? false)? convert.jsonEncode(params) : convert.jsonEncode({});
      http.Response response = await http.post(path, headers: headers, body:body);
      return generateResData(response, path, params);
    }catch(exception){
      return generateResData(null, null, params);
    }
  }


  /// Caller
  static Caller generateCaller(){
    return Caller('http', '39.98.209.45', 80, '', 'c4ca4238a0b923820dcc509a6f75849b', '45C8E8E80241E9F863D8ABC750DEAEA2D6F147B3BCB32A066D5E76B6C029E3C9436189F3F5FDE6AB', Random());
  }

}