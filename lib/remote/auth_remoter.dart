


import 'package:kcbweb_account_manage/data_models/auth_model.dart';
import 'package:kcbweb_account_manage/data_models/remote/remote_data.dart';
import 'package:kcbweb_account_manage/remote/config/fetch_factory.dart';

class AuthRemoter {

  static Future<RemoteData<AuthModel>> login(String account, String password) async {
    RemoteData res = await FetchFactory.post('', params: { 'account':account, 'password':password }, version: 'v200');
    if(res != null) {
      return RemoteData(res.statusCode, res.message, AuthModel.fromData(res.data));
    }
    return null;
  }
}