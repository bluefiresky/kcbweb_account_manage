
import 'package:flutter/material.dart';

import 'package:kcbweb_account_manage/common/ui_helper.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';
import 'package:kcbweb_account_manage/pages/widget/left_edge_controller.dart';

class CreateAccountPage extends StatefulWidget {

  final Map propsParams;
  final Function onChangeSubPage;

  CreateAccountPage({Key key, this.propsParams, this.onChangeSubPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {

  String id;
  String accountID;
  String accountName;
  String password;
  String remark;

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
  Widget _renderSubView(){
    return Container(
      alignment: Alignment.topCenter,
      child: Column(children: [
        this._renderInput('account-name', title: '账户名称：'),
        Divider(height: 15,),
        this._renderInput('account-id', title: '账户：'),
        Divider(height: 15,),
        this._renderInput('password', title: '密码：'),
        Divider(height: 15,),
        this._renderInput('remark', title: '备注：'),
        Divider(height: 66,),
        UIHelper.commonButton('提交', () {}, width: 310, height: 54, titleStyle: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold))
      ]),
    );
  }

  Widget _renderInput(String label, {String title, String value}){
    bool obscure = (label == 'password');
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 120, alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 10),
          child: Text(title, style: TextStyle(fontSize: 18, color: XColors.mainText),)
      ),
      Container(
          width: 500,
          child: TextField(
              obscureText: obscure,
              decoration: InputDecoration(labelText: '请输入', errorText: null, border: OutlineInputBorder()),
              onChanged: (String text){ this._onTextChanged(label, text); })
      )
    ]);
  }

  /// Api
  void _fetching() {
    // setState(() {});
  }

  /// Events
  void _onTextChanged(String label, String value){
    switch(label) {
      case 'account-name': this.accountName = value; break;
      case 'account-id': this.accountID = value; break;
      case 'password': this.password = value; break;
      case 'remark': this.remark = value; break;
    }
  }
  
}