

import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/config/custom_navigation.dart';
import 'package:kcbweb_account_manage/pages/home_page.dart';
import 'package:kcbweb_account_manage/pages/auth/login_page.dart';
import 'package:kcbweb_account_manage/route/route_name.dart' as RouteName;
import 'package:kcbweb_account_manage/route/routing_data.dart';
import 'package:kcbweb_account_manage/utility/common_utility.dart';
import 'package:kcbweb_account_manage/utility/extensions/string_extension.dart';
import 'package:kcbweb_account_manage/config/locator.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';
import 'package:kcbweb_account_manage/utility/login_helper.dart';



/// * 自定义路由 */
Route<dynamic> generateRoute(RouteSettings settings) {
  var routingData = settings.name.getRoutingData;

  if(routingData.route == RouteName.Default) {
    return _generateEmptyPage(settings);
  }
  else {
    Logger.w('000000 generateRoute  -->> ${routingData.route}');
    if(routingData.route == RouteName.LoginRoute) {
      return _generatePage(LoginPage(), settings);
    }
    else {
      if(!LoginHelper.checkAuth()) {
        CommonUtility.timeout(1000, (){ locator<CustomNavigation>().replaceTo(RouteName.LoginRoute); });
        return _generateEmptyPage(settings);
      }
      else {
        switch(routingData.route) {

          case RouteName.HomeRoute:
            return _generatePage(HomePage(), settings);

          default:
            CommonUtility.timeout(1000, (){ locator<CustomNavigation>().replaceTo(RouteName.HomeRoute); });
            return _generateEmptyPage(settings);
        }
      }
    }
  }
}

PageRoute _generatePage(Widget child, RouteSettings settings){
  return NoAnimationMaterialPageRoute(child: child, settings: settings);
}

PageRoute _generateEmptyPage(RouteSettings settings){
  return _generatePage(Container(), settings);
}


class NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationMaterialPageRoute({
    Widget child,
    RouteSettings settings,
  }) : super(builder: (context) => child, settings: settings);

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return child;
  }
}


/// 自定义路由跳转动画
class _AnimationRoute extends PageRouteBuilder {

  final Widget child;
  final RouteSettings settings;

  _AnimationRoute({this.child, this.settings}) :
    super(
      settings: RouteSettings(name: settings.name),
      transitionDuration: new Duration(milliseconds: 1),
      reverseTransitionDuration: new Duration(milliseconds: 1),
      pageBuilder:(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => child,
      transitionsBuilder:(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        /*** 淡入淡入 */
        return FadeTransition(
            opacity: Tween(begin: 0.0, end: 2.0).animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
            child: child
        );

        /*** 平移滑动 */
        // return SlideTransition(
        //   position: Tween<Offset>(
        //       begin: Offset(1.0, 0.0),
        //       end: Offset(0.0, 0.0)
        //   ).animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
        //   child: child,
        // );

        /*** 缩放 */
        // return ScaleTransition(
        //   scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
        //   child: child
        // );

        /*** 旋转+缩放 */
        // return RotationTransition(
        //   turns: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
        //   child: ScaleTransition(
        //     scale: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
        //     child: child,
        //   ),
        // );
      }
    );

}