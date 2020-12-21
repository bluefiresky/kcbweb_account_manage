
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/data_models/remote/pagination.dart';
import 'package:kcbweb_account_manage/data_models/remote/role_remote_data.dart';


class AccountModel {
  String id;
  String accountID;
  String account;
  String accountName;
  String password;
  String remark;
  RoleModel currentRole;

  AccountModel();

  AccountModel.fromData(Map data){
    if(data?.isNotEmpty ?? false) {
      this.id = data['id'] ?? '';
      this.accountID = data['accountID'] ?? '';
      this.account = data['account'] ?? '';
      this.accountName = data['accountName'] ?? '';
      this.password = data['password'] ?? '';
      this.remark = data['remark'] ?? '';
      this.currentRole = RoleModel.fromData(data['currentRole']);
    }
  }

  @override
  String toString() {
    return " ## id: $id -- accountID: $accountID -- accountName: $accountName -- password: $password -- remark: $remark -- currentRole :${currentRole.toString()}";
  }
}


class AccountListData {
  List<AccountModel> list = [];

  AccountListData.fromData(Map data) {
    List l = data['list'];
    int index = 0;
    l.forEach((element) {
      AccountModel item = AccountModel.fromData({
        'id':element['id'] ?? "",
        'account':element['account'] ?? "",
        'accountID':element['accountID'] ?? "",
        'accountName': element['accountName'] ?? "",
        'remark':element['remark'] ?? "",
      });
      this.list.add(item);
    });
  }
}