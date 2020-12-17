
import 'package:flutter/cupertino.dart';

class CustomNavigation {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName, {Map<String, String> queryParams}){
    if(queryParams != null) routeName = Uri(path: routeName, queryParameters: queryParams).toString();
    return navigatorKey.currentState.pushNamed(routeName);
  }

  Future<dynamic> replaceTo(String routeName, {Map<String, String> queryParams}){
    if(queryParams != null) routeName = Uri(path: routeName, queryParameters: queryParams).toString();
    return navigatorKey.currentState.pushReplacementNamed(routeName);
  }

  void pop(){
    navigatorKey.currentState.pop();
  }
}