
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/widget/x_button.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';
import 'package:kcbweb_account_manage/config/custom_navigation.dart';
import 'package:kcbweb_account_manage/config/locator.dart';
import 'package:kcbweb_account_manage/route/route_name.dart' as RouteName;
import 'package:kcbweb_account_manage/common/tip_helper.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {

  double inputW = 380;
  String account;
  String password;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: XColors.page,
      child: this._renderSubView(),
    );
    // // TODO: implement build
    // return Center(
    //   child: FlatButton(
    //     color: XColors.primary,
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    //     child: Text('登陆'),
    //     onPressed: () { locator<CustomNavigation>().replaceTo(RouteName.HomeRoute); },
    //   ),
    // );
  }

  Widget _renderSubView(){
    return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
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
  _onSubmit(){
    Logger.w(' 999999 -->> $account -- $password');
  }


  /// Event
  void _onTextChanged(String type, String value) {
    switch(type) {
      case 'account': this.account = value; break;
      case 'password': this.password = value; break;
    }
  }
}