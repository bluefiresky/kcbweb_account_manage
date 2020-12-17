
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/ui_helper.dart';
import 'package:kcbweb_account_manage/common/tip_helper.dart';

enum LeftEdgeItem {
  ENABLE_ACCOUNT_LIST,
  FORBIDDEN_ACCOUNT_LIST,
  ENABLE_ROLES_LIST,
  FORBIDDEN_ROLES_LIST
}

class LeftEdgeController extends StatefulWidget {
  final LeftEdgeItem currentItem;
  final Function onChangeItem;

  const LeftEdgeController({Key key, this.currentItem, this.onChangeItem}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LeftEdgeControllerState();
}

class LeftEdgeControllerState extends State<LeftEdgeController> {

  LeftEdgeItem _currentItem;
  final Map itemMap = {
    LeftEdgeItem.ENABLE_ACCOUNT_LIST: '启用平台账号列表',
    LeftEdgeItem.FORBIDDEN_ACCOUNT_LIST: '禁用平台账号列表',
    LeftEdgeItem.ENABLE_ROLES_LIST: '启用角色列表',
    LeftEdgeItem.FORBIDDEN_ROLES_LIST: '启用角色列表',
  };

  @override
  void initState() {
    super.initState();
    this._currentItem = widget.currentItem;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      color: Color.fromRGBO(34, 54, 89, 1),
      child:Column(children: [
        this._renderGroupTitle(title: '平台账号管理', icon: Icons.group),
        this._renderItem(itemKey: LeftEdgeItem.ENABLE_ACCOUNT_LIST),
        this._renderItem(itemKey: LeftEdgeItem.FORBIDDEN_ACCOUNT_LIST),
        this._renderGroupTitle(title: '平台角色管理', icon: Icons.group),
        this._renderItem(itemKey: LeftEdgeItem.ENABLE_ROLES_LIST),
        this._renderItem(itemKey: LeftEdgeItem.FORBIDDEN_ROLES_LIST),
      ]),
    );
  }

 Widget _renderGroupTitle({String title, IconData icon}){
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 10),
      child: Row(children: [
        Padding(child: Icon(icon), padding: EdgeInsets.only(right: 10)),
        Text(title, style: this._generateTextStyle('title'))
      ]),
    );
 }

  Widget _renderItem({LeftEdgeItem itemKey}){
    var title = itemMap[itemKey];
    var bg = itemKey == this._currentItem? Color.fromRGBO(0, 0, 0, 0.3) : Colors.transparent;
    return InkWell(
      child: Container(
        alignment: Alignment.centerLeft,
        height: 50,
        color: bg,
        padding: EdgeInsets.only(left: 76),
        child: Text(title, style: this._generateTextStyle('item'))
      ),
      onTap: () { this.onChangeItem(itemKey); },
    );
  }

  void onChangeItem(LeftEdgeItem leftEdgeItem) {
    if(this._currentItem != leftEdgeItem) {
      this._currentItem = leftEdgeItem;
      setState(() {
        if(widget.onChangeItem != null) { widget.onChangeItem(leftEdgeItem); }
      });
    }
  }

  TextStyle _generateTextStyle (type) {
    switch(type) {
      case 'title': return TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16);
      case 'item': return TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16);
      default: return TextStyle();
    }
  }

}