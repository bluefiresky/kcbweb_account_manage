
import 'package:flutter/material.dart';

class EditAccountRolePage extends StatefulWidget {

  final Map propsParams;
  final Function onChangeSubPage;

  EditAccountRolePage({Key key, this.propsParams, this.onChangeSubPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EditAccountRolePageState();
}

class EditAccountRolePageState extends State<EditAccountRolePage> {

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
    return Center(child: Text('EditAccountRolePage -- id -->> ${widget.propsParams['id']}'));
  }

  /// Api
  void _fetching() {
    // setState(() {});
  }

  /// Events
  void _onPress(){

  }
}