

import 'package:kcbweb_account_manage/data_models/auth_model.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';
import 'package:kcbweb_account_manage/utility/storage_helper.dart';

class LoginHelper {

  static void saveAuth(AuthModel auth){
    if(auth != null) {
      StorageHelper.sessionSave(StorageHelper.authKey, auth.toJson());
    }
  }

  static AuthModel getAuth(){
    String authJson = StorageHelper.sessionGet(StorageHelper.authKey);
    if(authJson != null && authJson.isNotEmpty) {
      AuthModel a = AuthModel.fromJson(authJson);
      return a;
    }
    return null;
  }


  static bool checkAuth(){
    String token = getAuth()?.token;
    return (token != null && token.isNotEmpty);
  }
}