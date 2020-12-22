
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';

import 'x_colors.dart';

class UIHelper {

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
