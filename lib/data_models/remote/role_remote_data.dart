

import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/data_models/role_model.dart';


class RoleListData {

  List<RoleModel> list = [];

  RoleListData(this.list);

  RoleListData.fromData(Map data){
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