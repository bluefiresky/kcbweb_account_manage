
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';

class UIHelper {

  /// 普通按钮，默认背景色 -- 蓝色
  static Widget commonButton(String title, Function onPress, { double height, Color bgColor, TextStyle titleStyle}){
    Color bc = bgColor == null? XColors.primary : bgColor;
    TextStyle ts = titleStyle == null? TextStyle(fontSize:14, color: Colors.white, fontWeight: FontWeight.normal) : titleStyle;
    double h = height == null? 44 : height;

    return FlatButton(
      color:bc, hoverColor: XColors.primaryHover, height: h, padding: EdgeInsets.only(left: 22, right: 22),
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent), borderRadius: BorderRadius.circular(5)),
      child: Text(title, style: ts),
      onPressed: onPress,
    );
  }



  /// 边框按钮，默认边框色: commonLine, 默认背景色: 白色
  static Widget borderButton(String title, Function onPress, {double height, Color bgColor, TextStyle titleStyle}){
    Color bc = bgColor == null? Colors.white : bgColor;
    TextStyle ts = titleStyle == null? TextStyle(fontSize:12, color: XColors.mainText, fontWeight: FontWeight.normal) : titleStyle;
    double h = height == null? 38 : height;

    return FlatButton(
      color:bc, height: h, padding: EdgeInsets.only(left: 15, right: 15),
      shape: RoundedRectangleBorder(side: BorderSide(color: XColors.commonLine, width: 1), borderRadius: BorderRadius.circular(5)),
      child: Text(title, style: ts),
      onPressed: onPress,
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
