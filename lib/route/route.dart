

import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/route/route_name.dart' as RouteName;
import 'package:kcbweb_account_manage/utility/extensions/string_extension.dart';


/// * 自定义路由 */
Route<dynamic> generateRoute(RouteSettings settings) {
  var routingData = settings.name.getRoutingData;

  switch(routingData.route) {
    case RouteName.LoginRoute:
      return _generatePage(Center(child: Text('登陆页面'),), settings);
    case RouteName.HomeRoute:
      return _generatePage(Center(child: Text('Home主页'),), settings);
    default:
      return _generatePage(Center(child: Text('登陆页面'),), settings);
  }

}


PageRoute _generatePage(Widget child, RouteSettings settings){
  return _AnimationRoute(child: child, routeName: settings.name);
}



/// 自定义路由跳转动画
class _AnimationRoute extends PageRouteBuilder {

  final Widget child;
  final String routeName;

  _AnimationRoute({this.child, this.routeName}) :
    super(
      settings: RouteSettings(name: routeName),
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