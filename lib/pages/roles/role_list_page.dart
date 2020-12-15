
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/tip_helper.dart';

enum RoleListType {
  ENABLE,
  FORBIDDEN
}

class RoleListPage extends StatefulWidget {

  final RoleListType listType;
  RoleListPage({Key key, this.listType}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RoleListPageState();
}

class RoleListPageState extends State<RoleListPage> {

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
    String type = widget.listType == RoleListType.ENABLE? '启用列表':'禁用列表';
    return Center(child: Text('RoleListPage -->> $type'));
  }

  /// Api
  void _fetching() {
    String type = widget.listType == RoleListType.ENABLE? '启用列表':'禁用列表';
    TipHelper.toast(msg: ' 11111190909099 -->> $type');
    // setState(() {});
  }

  /// Events
  void _onPress(){

  }
}