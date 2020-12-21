
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/tip_helper.dart';

import 'package:kcbweb_account_manage/common/ui_helper.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';
import 'package:kcbweb_account_manage/data_models/remote/account_remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote/remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote/role_remote_data.dart';
import 'package:kcbweb_account_manage/pages/widget/left_edge_controller.dart';
import 'package:kcbweb_account_manage/remote/account_remoter.dart';
import 'package:kcbweb_account_manage/remote/mock_data.dart';
import 'package:kcbweb_account_manage/remote/role_remoter.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';


class EditAccountPage extends StatefulWidget {

  final Map propsParams;
  final Function onChangeSubPage;

  EditAccountPage({Key key, this.propsParams, this.onChangeSubPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EditAccountPageState();
}

class EditAccountPageState extends State<EditAccountPage> {

  String id;
  List<RoleModel> roleList;
  AccountModel _accountDetail;

  double titleW = 120;
  double inputW = 500;


  @override
  void initState() {
    super.initState();
    this.id = widget.propsParams != null? widget.propsParams['id']:id;
    this._fetching();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft, color: XColors.page,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              this._renderBackView(),
              Expanded(child: Container(
                  alignment: Alignment.topLeft,
                  margin:EdgeInsets.all(20), padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(color:Colors.white, border: Border.all(width: 1, color: XColors.commonLine), borderRadius: BorderRadius.circular(20)),
                  child: SingleChildScrollView(child: this._renderSubView())
              ))
              //
            ])
    );
  }

  Widget _renderBackView(){
    return Container(
        alignment: Alignment.topLeft, margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: BoxDecoration(color:Colors.white, border: Border.all(width: 1, color: XColors.commonLine), borderRadius: BorderRadius.circular(5)),
        child: UIHelper.backButton((){ widget.onChangeSubPage(LeftEdgeItem.ENABLE_ACCOUNT_LIST, null); })
    );
  }


  /// SubView
  /// SubView
  Widget _renderSubView(){
    return Container(
      alignment: Alignment.topCenter,
      child: Column(children: [
        this._renderInput('account-name', title: '账户名称：'),
        Divider(height: 15, color: Colors.transparent,),
        this._renderInput('account-id', title: '账户：'),
        Divider(height: 15, color: Colors.transparent,),
        this._renderInput('password', title: '密码：'),
        Divider(height: 15, color: Colors.transparent,),
        this._renderDropdownRow('role-select', title: '角色：', value: this._accountDetail?.currentRole?.id),
        Divider(height: 15, color: Colors.transparent,),
        this._renderInput('remark', title: '备注：'),
        Divider(height: 66, color: Colors.transparent,),
        UIHelper.commonButton('提交', () { this._submit(); }, width: 310, height: 54, titleStyle: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold))
      ]),
    );
  }

  Widget _renderInput(String label, {String title, String value}){
    bool obscure = (label == 'password');
    int maxLines = (label == 'remark')? 5 : 1;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: this.titleW, alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 10),
          child: Text(title, style: TextStyle(fontSize: 18, color: XColors.mainText),)
      ),
      Container(
          width: this.inputW,
          child: TextField(
              style: TextStyle(fontSize: 16, height: 1.3),
              obscureText: obscure, maxLines: maxLines, minLines: 1,
              decoration: InputDecoration(labelText: '请输入', errorText: null, border: OutlineInputBorder()),
              onChanged: (String text){ this._onTextChanged(label, text); })
      )
    ]);
  }

  Widget _renderDropdownRow(String label, { String title, var value}){
    List items = this.roleList?.map((e) {
      return DropdownMenuItem(child: Text(e.roleName, style: TextStyle(height: 1.3, fontSize: 16)), value:e.id);
    })?.toList();

    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: this.titleW, alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 10),
          child: Text(title, style: TextStyle(fontSize: 18, color: XColors.mainText),)
      ),
      Container(
        width: this.inputW,
        child: DropdownButtonFormField(

          isExpanded: true, decoration: InputDecoration(labelText: '请选择角色', border: OutlineInputBorder()),
          items: items,
          value: value,
          onChanged: (value) {
            TipHelper.toast(msg: value.toString());
            List resultList = this.roleList.where((element) => (element.id == value)).toList();
            if(this._accountDetail?.currentRole != null) {
              this._accountDetail.currentRole = resultList.first;
              setState(() {});
            }
          },
        ),
      )
    ]);
  }


  /// Api
  void _fetching() async {
    RemoteData<RoleRemoteData> res = await RoleRemoter.getRoleList(pageNum: 1, pageLimit: 10);
    res = MockData.getRoleList(1, 10);
    this.roleList = res?.data?.list ?? [];

    RemoteData<AccountModel> accountRes = await AccountRemoter.getAccountDetail(id: '');
    if(accountRes?.statusCode == 200) {
      this._accountDetail = accountRes.data;
    }
    else {
      this._accountDetail = AccountModel();
    }
    setState(() {});
  }

  void _submit(){
    Logger.i(" 0099090 -->> ${this._accountDetail.toString()}");
  }

  /// Events
  void _onTextChanged(String label, String value){
    switch(label) {
      case 'account-name': this._accountDetail.accountName = value; break;
      case 'account-id': this._accountDetail.accountID = value; break;
      case 'password': this._accountDetail.password = value; break;
      case 'remark': this._accountDetail.remark = value; break;
    }
  }

}