
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/data_models/account_model.dart';


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