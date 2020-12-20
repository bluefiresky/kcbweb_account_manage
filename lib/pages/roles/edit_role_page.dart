
import 'package:flutter/material.dart';

class EditRolePage extends StatefulWidget {

  final Map propsParams;
  final Function onChangeSubPage;

  EditRolePage({Key key, this.propsParams, this.onChangeSubPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EditRolePageState();
}

class EditRolePageState extends State<EditRolePage> {

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
    return Center(child: Text('EditRolePage -- id -->> ${widget.propsParams['id']}'));
  }

  /// Api
  void _fetching() {
    // setState(() {});
  }

  /// Events
  void _onPress(){

  }
}