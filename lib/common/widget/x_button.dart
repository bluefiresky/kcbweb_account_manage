

import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';

class XButton extends StatelessWidget {

  final double width;
  final double height;
  final EdgeInsetsGeometry padding;

  final Function onPress;

  final String title;
  final TextStyle titleStyle;

  final BoxDecoration boxDecoration;

  XButton({
    this.width, this.height, padding, onPress,
    this.title = '', titleColor = XColors.mainText, titleSize = 12, titleStyle,
    color = Colors.white, border = false, boxDecoration,
    disable = false, disableColor = Colors.white, disableTitleColor = XColors.disabledButton
  }) :
      onPress = disable? null : onPress,
      titleStyle = titleStyle ?? TextStyle(color: disable? disableTitleColor : titleColor, fontSize: titleSize, fontWeight: FontWeight.normal),
      boxDecoration = boxDecoration ??
          border?
            BoxDecoration(color: disable? disableColor : color, border: Border.all(color: disable? XColors.disabledButton : XColors.commonLine, width: 1), borderRadius: BorderRadius.circular(4))
            :
            BoxDecoration(color: disable? disableColor : color, borderRadius: BorderRadius.circular(4)),
      padding = padding ?? EdgeInsets.only(left: 22, right: 22, top:16, bottom: 16);


  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width, height: this.height,
      decoration: this.boxDecoration,
      child: FlatButton(
        child: Text(title, style: this.titleStyle),
        onPressed: this.onPress,  hoverColor: XColors.primaryHover, padding: this.padding,),
    );
  }
}