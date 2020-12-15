
import 'package:flutter/material.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateAccountPageState();
}

class CreateAccountPageState extends State<CreateAccountPage> {

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
    return Center(child: Text('CreateAccountPage'));
  }

  /// Api
  void _fetching() {
    // setState(() {});
  }

  /// Events
  void _onPress(){

  }
}