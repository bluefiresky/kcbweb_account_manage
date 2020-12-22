

import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';

class XInputView extends StatefulWidget {

  final double titleWidth;
  final double inputWidth;

  final String title;
  final String keyword;
  final Function onChanged;
  final String placeholder;
  final bool obscure;
  final int maxLines;
  final bool enabled;
  final TextEditingController textEditingController;


  XInputView({this.onChanged, title, keyword, placeholder, obscure, maxLines, enabled, textEditingController, titleWidth, inputWidth}) :
        titleWidth = titleWidth ?? 120,
        inputWidth = inputWidth ?? 500,

        title = title ?? '',
        keyword = keyword ?? '',
        enabled = enabled ?? true,
        placeholder = (enabled ?? true)? placeholder ?? '' : '',
        obscure = obscure ?? false,
        maxLines = maxLines ?? 1,
        textEditingController = textEditingController ?? TextEditingController();

  @override
  State<StatefulWidget> createState() => XInputViewState();
}

class XInputViewState extends State<XInputView> {


  @override
  Widget build(BuildContext context) {
    widget.textEditingController.text = widget.keyword;

    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: widget.titleWidth, alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 10),
          child: Text(widget.title, style: TextStyle(fontSize: 18, color: XColors.mainText),)
      ),
      Container(
          width: widget.inputWidth,
          child: TextField(
              controller: widget.textEditingController,
              style: TextStyle(fontSize: 16, height: 1.3),
              obscureText: widget.obscure, maxLines: widget.maxLines, minLines: 1,
              decoration: InputDecoration(enabled: widget.enabled, labelText: widget.placeholder, errorText: null, border: OutlineInputBorder()),
              onChanged: (String text){ widget.onChanged(text); },
          )
      )
    ]);
  }


}