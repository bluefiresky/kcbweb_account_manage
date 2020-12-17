
import 'dart:async';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/tip_helper.dart';
import 'package:kcbweb_account_manage/common/ui_helper.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';
import 'package:kcbweb_account_manage/data_models/account_model.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';

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

  final List _tableHeaderTitles = ['ID', '账号', '账号名称', '操作'];
  List<AccountModal> _dataList = [];
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
    });
    this._fetching();
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft, color: XColors.page,
      child: ListView(children: [this._renderSubView()])
    );
  }

  /// SubView
  Widget _renderSubView(){
    List<TableRow> tableRowList = [this._renderTabHeader()];
    tableRowList.addAll(this._dataList.asMap().entries.map((e) => this._renderContentRow(e.key, e.value)).toList());

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 1040,
        margin: EdgeInsets.all(20), padding: EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, border: Border.all(color: XColors.commonLine, width: 1), borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UIHelper.commonButton('创建新账号', () {}),
          Divider(height: 40, color: XColors.commonLine, thickness: 1),
          Table(
            columnWidths: {0:FixedColumnWidth(200), 1:FixedColumnWidth(200), 2:FixedColumnWidth(200), 3:FlexColumnWidth(1)},
            children: tableRowList,
          ),
          this._renderPageNumNav()
        ]),
      )
    );
  }

  TableRow _renderTabHeader(){
    return TableRow(
      children: this._tableHeaderTitles.map((title){
        return Container(
            alignment: Alignment.centerLeft, height: 68, padding: EdgeInsets.only(right: 20),
            child: Text(title, style: TextStyle(color:Color.fromRGBO(86, 105, 141, 1), fontSize: 16, fontWeight: FontWeight.bold )));
      }).toList()
    );
  }
  
  TableRow _renderContentRow(int index, AccountModal item){
    return TableRow(
      decoration: BoxDecoration(color: (index%2 == 0)? Color.fromRGBO(246, 249, 253, 1) : Colors.white),
      children: [item.id, item.account, item.accountName, 'operation'].map((e){
        if(e == 'operation') {
          return Container(alignment: Alignment.centerLeft, height: 68, child: this._renderOperation());
        } else {
          return Container(
            alignment: Alignment.centerLeft, height:68, padding: EdgeInsets.only(right: 20),
            child: Text(e, maxLines: 2, overflow: TextOverflow.visible, style: TextStyle( height: 1.3, color:Color.fromRGBO(73, 73, 73, 1), fontSize: 15, fontWeight: FontWeight.normal )));
        }
      }).toList()
    );
  }

  Widget _renderOperation(){
    if(widget.listType == AccountListType.ENABLE) {
      return Row(children: [
        UIHelper.borderButton('修改信息', (){}),
        VerticalDivider(width: 15),
        UIHelper.borderButton('修改密码', (){}),
        VerticalDivider(width: 15),
        UIHelper.borderButton('修改角色', (){}),
        VerticalDivider(width: 15),
        UIHelper.borderButton('禁用', (){}),
      ]);
    } else {
      return null;
    }
  }

  Widget _renderPageNumNav(){
    if(this._dataList == null || this._dataList.length == 0) return UIHelper.emptyPage();
    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 30),
      alignment: Alignment.center,
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        UIHelper.borderButton('上一页', (){}),
        VerticalDivider(width: 15),
        UIHelper.borderButton('下一页', (){}),
      ]),
    );
  }

  /// Api
  void _fetching() {
    String type = widget.listType == AccountListType.ENABLE? '启用列表':'禁用列表';
    TipHelper.toast(msg: ' 列表类型 -->> $type');
    this._dataList.addAll(mock());
    setState(() {});
  }

  /// Events
  void _onPress(){

  }
}


/// Mock 数据
List<AccountModal> mock() {
  return List(6).asMap().map((i, e) => MapEntry(i, mockItem(i, e))).values.toList();
}

AccountModal mockItem(index, element) {
  return AccountModal(id: "IDIDIDIDIDIDID-${index+1}", account: '账号账号账号账号账号账号-${index+1}', accountName: '你猜猜你猜猜你猜猜你猜猜你猜猜-${index+1}');
}