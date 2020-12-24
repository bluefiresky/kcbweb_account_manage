

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kcbweb_account_manage/config/custom_navigation.dart';
import 'package:kcbweb_account_manage/config/locator.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:universal_html/html.dart' as html;



class Tipper {

  static int index = 0;

  static void toast({@required String msg, ToastGravity gravity, Toast toastLength}){
    if(msg != null && msg.isNotEmpty) {
      Fluttertoast.showToast(
          msg: msg,
          toastLength: toastLength != null? toastLength : Toast.LENGTH_SHORT,
          gravity: gravity != null? gravity : ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          webPosition: 'center',
          webBgColor: 'rgba(0,0,0,0.7)',
          fontSize: 16.0
      );
    }
  }

  static void dialog({BuildContext context, String title, String content, Function onLeftPress}){
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

  static void alert(String message){
    html.window?.alert(message);
  }

}
