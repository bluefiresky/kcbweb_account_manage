
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/tip_helper.dart';
import 'package:kcbweb_account_manage/common/widget/x_button.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';
import 'package:kcbweb_account_manage/data_models/remote/pagination.dart';
import 'package:kcbweb_account_manage/data_models/remote/remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote/role_remote_data.dart';
import 'package:kcbweb_account_manage/data_models/role_model.dart';
import 'package:kcbweb_account_manage/pages/widget/left_edge_controller.dart';
import 'package:kcbweb_account_manage/pages/widget/x_list_view.dart';
import 'package:kcbweb_account_manage/remote/mock_data.dart';
import 'package:kcbweb_account_manage/remote/role_remoter.dart';


enum RoleListType {
  ENABLE,
  FORBIDDEN
}

class RoleListPage extends StatefulWidget {

  final RoleListType listType;
  final Function onChangeSubPage;

  RoleListPage({Key key, this.listType, this.onChangeSubPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RoleListPageState();
}

class RoleListPageState extends State<RoleListPage> {

  BuildContext _context;

  final List _tableColumnWidth = [200, 200, 200, 400];
  final double _columnHeight = 88;
  final List _tableHeaderTitles = ['ID', '角色名称', '角色描述', '操作'];
  List<RoleModel> _dataList = [];
  Pagination _pagination;
  int _pageLimit = 10;
  int _pageNum = 1;


  @override
  void initState() {
    super.initState();
    this._fetching();
  }

  @override
  Widget build(BuildContext context) {
    this._context = context;

    return Container(
        color: XColors.page, alignment: Alignment.topLeft,
        child: this._renderSubView()
    );
  }

  /// SubView
  Widget _renderSubView(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
          width: 1050, margin: EdgeInsets.all(20), padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: XColors.commonLine, width: 1), borderRadius: BorderRadius.circular(20)),
          child: Column(children: [
            this._renderHeader(),
            Expanded(flex:1, child: this._renderList()),
            this._renderFooter()
          ])
      )
    );
  }


  Widget _renderHeader(){
    Widget createButton = widget.listType == RoleListType.ENABLE?
        XButton(title: '创建新角色', onPress: () { this._onChangeToOperatePage(LeftEdgeItem.CREATE_ROLE, {'id':'111'}); }, color: XColors.primary, titleColor: XColors.primaryText, titleSize: 15,)
        :
        Container(height: 36);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      createButton,
      Divider(height: 40, color: XColors.commonLine, thickness: 1),
      Row(children: this._tableHeaderTitles.asMap().entries.map((e) => Container(
          width: this._tableColumnWidth[e.key], alignment: Alignment.centerLeft, height: 68, padding: EdgeInsets.only(left: 20),
          child: Text(e.value, style: TextStyle(color:Color.fromRGBO(86, 105, 141, 1), fontSize: 16, fontWeight: FontWeight.bold ))
      )).toList())
    ]);
  }


  Widget _renderList(){
    return XListView(renderItem: (context, index) { return this._renderItem(context, index); }, itemCount: this._dataList.length, itemHeight: this._columnHeight);
  }


  Widget _renderItem(BuildContext context, int index) {
    RoleModel item = this._dataList[index];
    List rowList = [item.id, item.roleName, item.roleDesc, 'operation'];
    int rowItemIndex = 0;
    return Container(
      decoration: BoxDecoration(color: (index%2 == 0)? Color.fromRGBO(246, 249, 253, 1) : Colors.white),
      child: Row(children: rowList.map((e) {
        if(e == 'operation') {
          return Expanded(child: Container(padding: EdgeInsets.only(left: 20), child: this._renderOperation()));
        }
        else {
          return Container(
              width: this._tableColumnWidth[rowItemIndex++], padding: EdgeInsets.only(left: 20),
              child: Text('$e', style: TextStyle(height: 1.3, fontSize: 16, color: XColors.mainText))
          );
        }
      }).toList()),
    );
  }


  Widget _renderFooter(){
    int currentNum = this._pagination?.current ?? 1;
    int totalNum = this._pagination?.total ?? 0;
    int sumPageNum = (totalNum / this._pageLimit).ceil();
    List<Widget> pageNumList = List(sumPageNum).asMap().entries.map((e) =>
        XButton(width: 32, height: 32, title: e.key.toString(), onPress: (){ this._onChangeToPage(e.key); }, color: Colors.white, disableTitleColor: XColors.primary, disable: (e.key == currentNum))
    ).toList();

    if(pageNumList.length > 0) pageNumList.removeAt(0);

    List<Widget> children = [
      XButton(title: '上一页', onPress: () { this._onChangePage(-1); }, disable: (currentNum <= 1), color: Colors.white, border: true),
      VerticalDivider(width: 15, color: Colors.transparent),
      VerticalDivider(width: 15, color: Colors.transparent),
      XButton(title: '下一页', onPress: () { this._onChangePage(1); }, disable: (currentNum >= sumPageNum), color: Colors.white, border: true)
    ];
    children.insertAll(2, pageNumList);

    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 30),
      alignment: Alignment.center,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: children),
    );
  }

  Widget _renderOperation(){
    if(widget.listType == RoleListType.ENABLE) {
      return Row(children: [
        XButton(title: '修改信息', onPress: (){ this._onChangeToOperatePage(LeftEdgeItem.EDIT_ROLE, {'id':'222'}); }, color: Colors.white, border: true),
        VerticalDivider(width: 15, color: Colors.transparent),
        XButton(title: '禁用', onPress: (){ this._operateDialog('forbidden'); }, color: Colors.white, border: true),
      ]);
    } else {
      return Row(children: [
        XButton(title: '启用', onPress: (){ this._operateDialog('enable'); }, color: Colors.white, border: true),
      ]);
    }
  }


  /// Api
  void _fetching() async {
    String listDesc = widget.listType == RoleListType.ENABLE?'启用列表':'禁用列表';

    RemoteData<RoleListData> listRes = await RoleRemoter.getRoleList(pageNum: this._pageNum, pageLimit: this._pageLimit);
    listRes = MockData.getRoleList(this._pageNum, this._pageLimit);
    this._dataList = listRes?.data?.list ?? [];
    this._pagination = listRes.pagination;

    setState(() {});
  }



  /// Events
  void _onChangeToOperatePage(LeftEdgeItem edgeItem, Map params){
    widget.onChangeSubPage(edgeItem, params);
  }

  void _onChangePage(int change){
    this._pageNum += change;
    this._fetching();
  }

  void _onChangeToPage(int page) {
    if(this._pageNum == page) return;
    this._pageNum = page;
    this._fetching();
  }

  void _operateDialog(String operate){
    if(operate == 'enable') {
      Tipper.dialog(context: this._context, title: '是否确定启用角色', content: '启用启用启用启用启用', onLeftPress: (){});
    }
    else if(operate == 'forbidden') {
      Tipper.dialog(context: this._context, title: '是否确定禁用角色', content: '停用停用停用停用停用', onLeftPress: (){});
    }
  }
}