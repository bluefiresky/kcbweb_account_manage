


import 'package:kcbweb_account_manage/data_models/auth_model.dart';
import 'package:kcbweb_account_manage/data_models/remote/remote_data.dart';
import 'package:kcbweb_account_manage/remote/config/fetch_factory.dart';
import 'package:kcbweb_account_manage/remote/model/api-helper.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';
import 'package:kcbweb_account_manage/remote/model/session/api.dart' as sessionApi;


class AuthRemoter {

  // 账号：administrator 密码：123456 pin：0
  static Future<RemoteData<AuthModel>> login(String account, String password) async {

    try {
      Tuple<String, String> res = await sessionApi.login(FetchFactory.generateCaller(), account, password, 0);
      String token = res.a;
      String refreshToken = res.b;
      return null;
    }catch(ex) {
      Logger.e("login remoter error ", object: ex);
      return null;
    }


    // RemoteData res = await FetchFactory.post('', params: { 'account':account, 'password':password }, version: 'v200');
    // if(res != null) {
    //   return RemoteData(res.statusCode, res.message, AuthModel.fromData(res.data));
    // }
    return null;
  }
}