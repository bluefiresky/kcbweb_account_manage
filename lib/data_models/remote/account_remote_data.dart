
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/data_models/remote/pagination.dart';


class AccountRemoteData {
  List<AccountModal> list = [];
  Pagination pagination;

  AccountRemoteData(this.list, this.pagination);

  AccountRemoteData.fromJson(Map data, { int current, int pageSize }) {
    List l = data['list'];
    int index = 0;
    l.forEach((element) {
      this.list.add(AccountModal(id: element['id'], account:element['mobileNumber'], accountName: element['nickName']));
    });
    pagination = Pagination(total: 100, current: current, pageSize: pageSize);
  }
}


class AccountModal {
  String id;
  String account;
  String accountName;

  AccountModal({@required this.id, @required this.account, @required this.accountName});
}