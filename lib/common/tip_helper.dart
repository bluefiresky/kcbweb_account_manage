

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kcbweb_account_manage/config/custom_navigation.dart';
import 'package:kcbweb_account_manage/config/locator.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';


class TipHelper {

  static void toast({String msg, ToastGravity gravity, Toast toastLength}){
    if(msg != null && msg.isNotEmpty) {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: toastLength != null? toastLength : Toast.LENGTH_SHORT,
          gravity: gravity != null? gravity : ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          webPosition: 'center',
          webBgColor: 'rgba(0,0,0,0.6)',
          fontSize: 16.0
      );
    }
  }

  static void alert({BuildContext context, String title, String content, Function onLeftPress}){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              FlatButton(child: Text('确定'), onPressed: onLeftPress),
              FlatButton(child: Text('取消'), onPressed: () { locator<CustomNavigation>().pop(); })
            ],
          );
        }
    );
  }

}
