
import 'dart:convert';


class AuthModel {

  String userId;
  String token;

  AuthModel(this.userId, this.token);

  AuthModel.fromData(Map data){
    this.userId = data['userId'];
    this.token = data['token'];
  }

  static String toJson(AuthModel model){
    return jsonEncode(model.toMap());
  }

  static AuthModel toModel(String json){
    return AuthModel.fromData(jsonDecode(json) as Map);
  }

  Map toMap(){
    return { 'userId':this.userId, 'token':this.token };
  }

  @override
  String toString() {
    return 'the userId -->> $userId and the token -->> $token';
  }
}