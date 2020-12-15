
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/tip_helper.dart';

enum AccountListType {
  ENABLE,
  FORBIDDEN
}

class AccountListPage extends StatefulWidget {

  final AccountListType listType;
  AccountListPage({Key key, this.listType}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AccountListPageState();
}

class AccountListPageState extends State<AccountListPage> {

  @override
  void initState() {
    super.initState();
    this._fetching();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: this._renderSubView());
  }

  /// SubView
  Widget _renderSubView(){
    String type = widget.listType == AccountListType.ENABLE? '启用列表':'禁用列表';
    return Center(child: Text('AccountListPageState -->> $type'));
  }

  /// Api
  void _fetching() {
    String type = widget.listType == AccountListType.ENABLE? '启用列表':'禁用列表';
    TipHelper.toast(msg: ' wozaijinxingzhong -->> $type');
    // setState(() {});
  }

  /// Events
  void _onPress(){

  }
}