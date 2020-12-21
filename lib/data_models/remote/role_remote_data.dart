

import 'package:flutter/cupertino.dart';
import 'package:kcbweb_account_manage/data_models/remote/pagination.dart';

class RoleModel {
  String id;
  String roleName;
  String roleDesc;

  RoleModel();

  RoleModel.fromData(Map data){
    if(data?.isNotEmpty ?? false) {
      this.id = data['id'] ?? '';
      this.roleName = data['roleName'] ?? '';
      this.roleDesc = data['roleDesc'] ?? '';
    }
  }

  @override
  String toString() {
    return " ## id: $id -- roleName: $roleName -- roleDesc: $roleDesc";
  }
}


class RoleRemoteData {

  List<RoleModel> list = [];

  RoleRemoteData(this.list);

  RoleRemoteData.fromData(Map data){
    List l = data['list'];
    int index = 0;
    l.forEach((element) {
      RoleModel item = RoleModel.fromData({
        'id':element['id'] ?? "",
        'roleName':element['roleName'] ?? "",
        'roleDesc':element['roleDesc'] ?? ""
      });
      this.list.add(item);
    });
  }

}