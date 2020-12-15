
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/config/custom_navigation.dart';
import 'package:kcbweb_account_manage/config/locator.dart';
import 'package:kcbweb_account_manage/route/route_name.dart' as RouteName;
import 'package:kcbweb_account_manage/common/tip_helper.dart' as TipHelper;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: RaisedButton(
        child: Text('登陆'),
        onPressed: () { locator<CustomNavigation>().navigateTo(RouteName.HomeRoute); },
      ),
    );
  }
}