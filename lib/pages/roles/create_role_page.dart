
import 'package:flutter/material.dart';

class CreateRolePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateRolePageState();
}

class CreateRolePageState extends State<CreateRolePage> {

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
    return Center(child: Text('CreateRolePage'));
  }

  /// Api
  void _fetching() {
    // setState(() {});
  }

  /// Events
  void _onPress(){

  }
}