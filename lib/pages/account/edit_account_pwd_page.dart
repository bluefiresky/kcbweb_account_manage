
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/ui_helper.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';
import 'package:kcbweb_account_manage/data_models/remote/account_remote_data.dart';
import 'package:kcbweb_account_manage/pages/widget/left_edge_controller.dart';
import 'package:kcbweb_account_manage/pages/widget/x_input_view.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';

class EditAccountPwdPage extends StatefulWidget {

  final Map propsParams;
  final Function onChangeSubPage;

  EditAccountPwdPage({Key key, this.propsParams, this.onChangeSubPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EditAccountPwdPageState();
}

class EditAccountPwdPageState extends State<EditAccountPwdPage> {

  String id;
  AccountModel _accountDetail;


  @override
  void initState() {
    super.initState();
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
            Expanded(child: this._renderSubView())
          ],
        )
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
      alignment: Alignment.topLeft,
      margin:EdgeInsets.all(20), padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color:Colors.white, border: Border.all(width: 1, color: XColors.commonLine), borderRadius: BorderRadius.circular(20)),
      child: this._renderInputView(),
    );
  }

  Widget _renderInputView(){
    return Column(
      children: [
        this._renderInputRow('accountID', '账号'),
        Divider(height: 15, color: Colors.transparent),
        this._renderInputRow('password', '密码'),
        Divider(height: 66, color: Colors.transparent,),
        UIHelper.commonButton('提交', () { this._submit(); }, width: 310, height: 54, titleStyle: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold))
      ],
    );
  }

  Widget _renderInputRow(String label, String title){
    bool obscure = (label == 'password');
    bool readOnly = (label == 'accountID');

    return XInputView(
        title: title, placeholder: '请输入', obscure: obscure, readOnly: readOnly,
        onChanged: (String value) { this._onTextChanged(label, value); },
    );
  }

  /// Api
  void _fetching() {
    // setState(() {});
    this._accountDetail = AccountModel();
  }

  /// Events
  void _submit(){
    Logger.i(" 88888888 -->> ${this._accountDetail.toString()}");
  }

  void _onTextChanged(String label, String value) {
    switch(label){
      case 'password': this._accountDetail.password = value; break;
    }
  }
}