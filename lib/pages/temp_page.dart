
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';

class TempPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => TempPageState();
}

class TempPageState extends State<TempPage> {

  @override
  void initState() {
    super.initState();
    this._fetching();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: XColors.page, alignment: Alignment.topLeft,
        child: this._renderSubView()
    );
  }

  /// SubView
  Widget _renderSubView(){
    return Center(child: Text('Temp Page'));
  }

  /// Api
  void _fetching() {
    // setState(() {});
  }

  /// Events
  void _onPress(){

  }
}