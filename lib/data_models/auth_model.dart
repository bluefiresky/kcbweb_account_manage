
import 'dart:convert';


class AuthModel {

  String userId;
  String account;
  String token;

  AuthModel(this.userId, this.account, this.token);

  AuthModel.fromData(Map data){
    this.userId = data['userId'];
    this.token = data['token'];
    this.account = data['account'];
  }

  AuthModel.fromJson(String json){
    Map data = jsonDecode(json);
    this.userId = data['userId'];
    this.token = data['token'];
    this.account = data['account'];
  }

  String toJson(){
    return jsonEncode(this.toMap());
  }

  Map toMap(){
    return { 'userId':this.userId, 'token':this.token, 'account':this.account };
  }

  @override
  String toString() {
    return 'userId -->> $userId && account -->> $account && token -->> $token ';
  }
}