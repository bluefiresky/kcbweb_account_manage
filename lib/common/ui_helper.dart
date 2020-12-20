
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';

import 'x_colors.dart';

class UIHelper {

  /// 普通按钮，默认背景色 -- 蓝色
  static Widget commonButton(String title, Function onPress, { bool disabled, double width, double height, Color bgColor, TextStyle titleStyle}){
    Color bc = bgColor == null? XColors.primary : bgColor;
    TextStyle ts = titleStyle == null? TextStyle(fontSize:14, color: Colors.white, fontWeight: FontWeight.normal) : titleStyle;
    double h = height == null? 44 : height;
    var pressEvent = disabled == true? null : onPress;

    return FlatButton(
      color:bc, hoverColor: XColors.primaryHover, minWidth: width, height: h, padding: EdgeInsets.only(left: 22, right: 22),
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(5)),
      child: Text(title, style: ts),
      onPressed: pressEvent,
    );
  }



  /// 边框按钮，默认边框色: commonLine, 默认背景色: 白色
  static Widget borderButton(String title, Function onPress, { bool disabled, double height, Color bgColor, TextStyle titleStyle}){
    Color bc = bgColor == null? Colors.white : bgColor;
    TextStyle ts = titleStyle == null? TextStyle(fontSize:12, color: (disabled == true)? XColors.disabledButton : XColors.mainText, fontWeight: FontWeight.normal) : titleStyle;
    double h = height == null? 38 : height;
    var pressEvent = disabled == true? null : onPress;

    return FlatButton(
      color:bc, height: h, padding: EdgeInsets.only(left: 15, right: 15),
      shape: RoundedRectangleBorder(side: BorderSide(color: (disabled == true)? XColors.disabledButton : XColors.commonLine, width: 1), borderRadius: BorderRadius.circular(5)),
      child: Text(title, style: ts),
      onPressed: pressEvent,
    );
  }

  /// Block Button 无背景，无边框，正方形, 可设置匡高
  static Widget blockButton(String title, Function onPress, { bool disabled, double height, double width, Color bgColor, Color borderColor, Color titleColor, TextStyle titleStyle}){
    Color bc = bgColor == null? Colors.white : bgColor;
    Color borderc = borderColor == null? Colors.transparent : disabled == true? XColors.disabledButton : borderColor;
    TextStyle ts = titleStyle == null? TextStyle(fontSize:12, color: (disabled == true)? XColors.disabledButton : (titleColor != null)? titleColor : XColors.mainText, fontWeight: FontWeight.normal) : titleStyle;
    double h = height != null? height : 30;
    var pressEvent = disabled == true? null : onPress;

    return SizedBox(
      width: width != null? width : 30, height: h,
      child: FlatButton(
        color:bc, height: h,
        shape: RoundedRectangleBorder(side: BorderSide(color: borderc, width: 1), borderRadius: BorderRadius.circular(5)),
        child: Text(title, style: ts),
        onPressed: pressEvent,
      ),
    );
  }


  /// Back Button, IconButton
  static Widget backButton(Function onPress, { Color bgColor }){
    Color bg = bgColor == null? Colors.white : bgColor;

    return Container(
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(5)),
      child: IconButton(icon: Icon(Icons.arrow_back), onPressed: () { onPress(); },),
    );
  }



  /// Empty Widget
  static Widget emptyPage(){
    return Container();
  }



  /// 测试border
  static BoxDecoration testBorder ({Color color}) {
    if(color == null) color = Colors.black;
    return BoxDecoration(border: Border.all(color:color, width: 1.5));
  }

}
