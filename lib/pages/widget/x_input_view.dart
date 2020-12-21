

import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';

class XInputView extends StatefulWidget {

  final double titleWidth;
  final double inputWidth;

  final String title;
  final Function onChanged;
  final String placeholder;
  final bool obscure;
  final int maxLines;
  final bool readOnly;


  XInputView({this.title, this.onChanged, this.placeholder, this.obscure, this.maxLines, readOnly, titleWidth, inputWidth}) :
        titleWidth = titleWidth ?? 120, inputWidth = inputWidth ?? 500, readOnly = readOnly ?? false;

  @override
  State<StatefulWidget> createState() => XInputViewState();
}

class XInputViewState extends State<XInputView> {


  @override
  Widget build(BuildContext context) {

    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: widget.titleWidth, alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 10),
          child: Text(widget.title, style: TextStyle(fontSize: 18, color: XColors.mainText),)
      ),
      Container(
          width: widget.inputWidth,
          child: TextField(
              readOnly: widget.readOnly,
              style: TextStyle(fontSize: 16, height: 1.3),
              obscureText: widget.obscure, maxLines: widget.maxLines ?? 1, minLines: 1,
              decoration: InputDecoration(labelText: widget.placeholder ?? '', errorText: null, border: OutlineInputBorder()),
              onChanged: (String text){ widget.onChanged(text); })
      )
    ]);
  }


}