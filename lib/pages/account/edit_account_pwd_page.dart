
import 'package:flutter/material.dart';

class EditAccountPwdPage extends StatefulWidget {

  final Map propsParams;
  final Function onChangeSubPage;

  EditAccountPwdPage({Key key, this.propsParams, this.onChangeSubPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EditAccountPwdPageState();
}

class EditAccountPwdPageState extends State<EditAccountPwdPage> {

  @override
  void initState() {
    super.initState();
    this._fetching();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: this._renderSubView());
  }

  /// SubView
  Widget _renderSubView(){
    return Center(child: Text('EditAccountPwdPage -- id -->> ${widget.propsParams['id']}'));
  }

  /// Api
  void _fetching() {
    // setState(() {});
  }

  /// Events
  void _onPress(){

  }
}