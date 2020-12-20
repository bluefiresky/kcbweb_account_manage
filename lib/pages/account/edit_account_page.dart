
import 'package:flutter/material.dart';

class EditAccountPage extends StatefulWidget {

  final Map propsParams;
  final Function onChangeSubPage;

  EditAccountPage({Key key, this.propsParams, this.onChangeSubPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EditAccountPageState();
}

class EditAccountPageState extends State<EditAccountPage> {

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
    return Center(child: Text('EditAccountPage -- id -->> ${widget.propsParams['id']}'));
  }

  /// Api
  void _fetching() {
    // setState(() {});
  }

  /// Events
  void _onPress(){

  }
}