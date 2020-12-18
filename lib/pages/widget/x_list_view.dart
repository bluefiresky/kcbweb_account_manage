
import 'package:flutter/material.dart';

class XListView extends StatefulWidget{

  final Widget renderHeader;
  final Widget renderFooter;
  final NullableIndexedWidgetBuilder renderItem;
  final double itemHeight;
  final int itemCount;

  XListView({this.renderHeader, this.renderItem, this.renderFooter, this.itemCount, this.itemHeight});

  @override
  State<StatefulWidget> createState() => XListViewState();
}

class XListViewState extends State<XListView> {

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [this._renderHeader(), this._renderList(), this._renderFooter()]);
  }

  SliverToBoxAdapter _renderHeader(){
    return SliverToBoxAdapter(child: widget.renderHeader);
  }

  SliverFixedExtentList _renderList(){
    return SliverFixedExtentList(
      itemExtent: widget.itemHeight,
      delegate: SliverChildBuilderDelegate(
          (context, index) { return widget.renderItem(context, index);},
          childCount: widget.itemCount
      ),
    );
  }

  SliverToBoxAdapter _renderFooter(){
    return SliverToBoxAdapter(child: widget.renderFooter);
  }
}