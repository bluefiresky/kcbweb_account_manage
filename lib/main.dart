import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/config/custom_navigation.dart';
import 'package:kcbweb_account_manage/config/locator.dart';
import 'package:kcbweb_account_manage/layout/layout_template/layout_template.dart';
import 'package:kcbweb_account_manage/route/route.dart' as Route;
import 'package:kcbweb_account_manage/route/route_name.dart' as RouteName;


void main() {
  setupLocator();
  runApp(RootView());
}

class RootView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RootViewState();
}

class RootViewState extends State<RootView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue, highlightColor: Colors.transparent, splashColor: Colors.transparent),
      title: '账号管理系统',
      builder: (context, child) => LayoutTemplate(child: child),
      navigatorKey: locator<CustomNavigation>().navigatorKey,
      onGenerateRoute: Route.generateRoute,
      initialRoute: RouteName.LoginRoute,
    );
  }
}