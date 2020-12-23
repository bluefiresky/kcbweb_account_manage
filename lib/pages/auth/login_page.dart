
import 'package:flutter/material.dart';

import 'package:kcbweb_account_manage/common/widget/x_button.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';
import 'package:kcbweb_account_manage/config/custom_navigation.dart';
import 'package:kcbweb_account_manage/config/locator.dart';
import 'package:kcbweb_account_manage/data_models/auth_model.dart';
import 'package:kcbweb_account_manage/data_models/remote/remote_data.dart';
import 'package:kcbweb_account_manage/remote/auth_remoter.dart';
import 'package:kcbweb_account_manage/remote/mock_data.dart';
import 'package:kcbweb_account_manage/route/route_name.dart' as RouteName;
import 'package:kcbweb_account_manage/common/tip_helper.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';
import 'package:kcbweb_account_manage/utility/storage_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  double inputW = 380;
  String account;
  String password;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: XColors.page,
      child: this._renderSubView(),
    );
  }

  Widget _renderSubView(){
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('账号管理系统', style: TextStyle(color: XColors.menuBg, fontSize: 40, fontWeight: FontWeight.bold)),
      Divider(height: 60, color: Colors.transparent),
      this._renderInputItem('account', '账号', '请输入账号', Icons.person_outline),
      Divider(height: 30, color: Colors.transparent),
      this._renderInputItem('password', '密码', '请输入密码', Icons.lock_outline),
      Divider(height: 60, color: Colors.transparent),
      this._renderSubmit(),
      Divider(height: 200, color: Colors.transparent),
    ],));
  }

  Widget _renderInputItem(String type, String labelText, String placeholder, IconData prefixIcon){
    bool obscure = (type == 'password');

    return Container(
      width: this.inputW,
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefixIcon: Icon(prefixIcon),
          labelText: labelText,
          hintText: placeholder,
          filled: true,
          fillColor: Colors.white
        ),
        obscureText: obscure,
        onChanged: (value) { this._onTextChanged(type, value); },
      ),
    );
  }

  Widget _renderSubmit(){
    return XButton(title: '登录', onPress: this._onSubmit, titleSize: 18, titleColor: XColors.primaryText, color: XColors.primary, width: this.inputW, height: 50);
  }


  /// Api
  _onSubmit() async {
    if(this.account?.isEmpty ?? true) TipHelper.toast(msg: '请输入账号');
    else if(this.password?.isEmpty ?? true) TipHelper.toast(msg: '请输入登录密码');
    else {
      RemoteData<AuthModel> res = await AuthRemoter.login(this.account, this.password);
      res = MockData.login(this.account, this.password);
      if(res != null) {
        StorageHelper.save(StorageHelper.authKey, AuthModel.toJson(res.data));
        locator<CustomNavigation>().replaceTo(RouteName.HomeRoute);
      }
    }
  }


  /// Event
  void _onTextChanged(String type, String value) {
    switch(type) {
      case 'account': this.account = value; break;
      case 'password': this.password = value; break;
    }
  }
}