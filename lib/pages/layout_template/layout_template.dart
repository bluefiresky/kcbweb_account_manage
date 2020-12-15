

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LayoutTemplate extends StatelessWidget {

  final Widget child;
  LayoutTemplate({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(children: [child],),
        );
      },
    );
  }




}