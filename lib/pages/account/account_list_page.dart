
import 'dart:async';
import 'dart:html';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/tip_helper.dart';
import 'package:kcbweb_account_manage/common/ui_helper.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';
import 'package:kcbweb_account_manage/data_models/remote/account_remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote/pagination.dart';
import 'package:kcbweb_account_manage/data_models/remote_data.dart';
import 'package:kcbweb_account_manage/pages/widget/x_list_view.dart';
import 'package:kcbweb_account_manage/remote/account_remoter.dart';
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

  final List _tableColumnWidth = [200, 200, 200, 400];
  final double _columnHeight = 66;
  final List _tableHeaderTitles = ['ID', '账号', '账号名称', '操作'];
  List<AccountModal> _dataList = [];
  Pagination _pagination;
  int _pageLimit = 8;
  int _pageNum = 1;

  @override
  void initState() {
    super.initState();
    this._fetching();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft, color: XColors.page,
      child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Container(
          width: 1050, margin: EdgeInsets.all(20), padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: XColors.commonLine, width: 1), borderRadius: BorderRadius.all(Radius.circular(20))),
          child: this._renderSubView()),)
    );
  }

  /// SubView
  Widget _renderSubView(){
    return Column(children: [
      this._renderHeader(),
      Expanded(flex:1, child: this._renderList()),
      this._renderFooter()
    ]);
  }


  Widget _renderList(){
    return XListView(
      // renderHeader: this._renderHeader(),
      // renderFooter: this._renderFooter(),
      itemCount: this._dataList.length,
      itemHeight: this._columnHeight,
      renderItem: (context, index) {
        AccountModal item = this._dataList[index];
        List temp = [item.id, item.account, item.accountName, 'operation'];
        return Container(
          decoration: BoxDecoration(color: (index%2 == 0)? Color.fromRGBO(246, 249, 253, 1) : Colors.white),
          child: Row(children: temp.asMap().entries.map((e) {
            if(e.value == 'operation') {
              return Container(alignment: Alignment.centerLeft, padding: EdgeInsets.only(left:20), height: 68, child: this._renderOperation());
            } else {
              return Container(
                width:this._tableColumnWidth[e.key], alignment: Alignment.centerLeft, height:68, padding: EdgeInsets.only(left: 20),
                child: Text(e.value, maxLines: 2, overflow: TextOverflow.visible, style: TextStyle( height: 1.3, color:Color.fromRGBO(73, 73, 73, 1), fontSize: 15, fontWeight: FontWeight.normal )));
            }
          }).toList()),
        );
      },
    );
  }

  Widget _renderHeader(){
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      UIHelper.commonButton('创建新账号', () {}),
      Divider(height: 40, color: XColors.commonLine, thickness: 1),
      Row(children: this._tableHeaderTitles.asMap().entries.map((e) => Container(
        width: this._tableColumnWidth[e.key], alignment: Alignment.centerLeft, height: 68, padding: EdgeInsets.only(left: 20),
        child: Text(e.value, style: TextStyle(color:Color.fromRGBO(86, 105, 141, 1), fontSize: 16, fontWeight: FontWeight.bold ))
      )).toList())
    ]);
  }

  Widget _renderFooter(){
    if(this._dataList == null || this._dataList.length == 0) return UIHelper.emptyPage();

    int currentNum = (this._pagination != null)? this._pagination.current : 1;
    int totalNum = (this._pagination != null)? this._pagination.total : 0;
    int sumPageNum = (totalNum / this._pageLimit).ceil();
    List<Widget> pageNumList = List(sumPageNum).asMap().entries.map((e) => UIHelper.blockButton(e.key.toString(), (){ this._onChangeToPage(e.key); }, titleColor: (e.key == currentNum)? XColors.primary : XColors.mainText)).toList();
    pageNumList.removeAt(0);
    List<Widget> children = [
      UIHelper.borderButton('上一页', (){ this._onChangePage(-1); }, disabled: (currentNum <= 1)),
      VerticalDivider(width: 15, color: Colors.transparent),
      VerticalDivider(width: 15, color: Colors.transparent),
      UIHelper.borderButton('下一页', (){ this._onChangePage(1);}, disabled: (currentNum >= sumPageNum))
    ];
    children.insertAll(2, pageNumList);

    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 30),
      alignment: Alignment.center,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: children),
    );
  }


  Widget _renderOperation(){
    if(widget.listType == AccountListType.ENABLE) {
      return Row(children: [
        UIHelper.borderButton('修改信息', (){}),
        VerticalDivider(width: 15, color: Colors.transparent),
        UIHelper.borderButton('修改密码', (){}),
        VerticalDivider(width: 15, color: Colors.transparent),
        UIHelper.borderButton('修改角色', (){}),
        VerticalDivider(width: 15, color: Colors.transparent),
        UIHelper.borderButton('禁用', (){}),
      ]);
    } else {
      return Row(children: [
        UIHelper.borderButton('启用', (){}),
      ]);
    }
  }



  /// Api
  void _fetching() async {
    String type = widget.listType == AccountListType.ENABLE? '启用列表':'禁用列表';
    TipHelper.toast(msg: 'Current List -->> $type');
    RemoteData<AccountRemoteData> res =  await AccountRemoter.getAccountList(pageNum: this._pageNum, pageLimit: this._pageLimit);
    if(res != null && res.data != null && res.data.list != null) {
      this._dataList = res.data.list;
      this._pagination = res.data.pagination;
      setState(() {});
    }
  }



  /// Events
  void _onChangePage(int change){
    this._pageNum += change;
    this._fetching();
  }

  void _onChangeToPage(int page) {
    if(this._pageNum == page) return;
    this._pageNum = page;
    this._fetching();
  }
}


/// Mock 数据
RemoteData mock() {
  List list = List(6).asMap().map((i, e) => MapEntry(i, mockItem(i, e))).values.toList();
  return RemoteData(200, '', AccountRemoteData);
}

AccountModal mockItem(index, element) {
  return AccountModal(id: "IDIDIDIDIDIDID-${index+1}", account: '账号账号账号账号账号账号-${index+1}', accountName: '你猜猜你猜猜你猜猜你猜猜你猜猜-${index+1}');
}