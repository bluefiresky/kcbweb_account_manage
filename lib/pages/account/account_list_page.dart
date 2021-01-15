
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/tip_helper.dart';
import 'package:kcbweb_account_manage/common/ui_helper.dart';
import 'package:kcbweb_account_manage/common/widget/x_button.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';
import 'package:kcbweb_account_manage/data_models/account_model.dart';
import 'package:kcbweb_account_manage/data_models/remote/account_remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote/pagination.dart';
import 'package:kcbweb_account_manage/data_models/remote/remote_data.dart';
import 'package:kcbweb_account_manage/pages/widget/x_list_view.dart';
import 'package:kcbweb_account_manage/remote/account_remoter.dart';
import 'package:kcbweb_account_manage/pages/widget/left_edge_controller.dart';


enum AccountListType {
  ENABLE,
  FORBIDDEN
}

class AccountListPage extends StatefulWidget {

  final AccountListType listType;
  final Function onChangeSubPage;

  AccountListPage({Key key, this.listType, this.onChangeSubPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AccountListPageState();
}

class AccountListPageState extends State<AccountListPage> {

  BuildContext _context;

  final List _tableColumnWidth = [200, 200, 200, 400];
  final double _columnHeight = 66;
  final List _tableHeaderTitles = ['ID', '账号', '账号名称', '操作'];
  List<AccountModel> _dataList = [];
  Pagination1 _pagination;
  int _pageLimit = 10;
  int _pageNum = 1;

  @override
  void initState() {
    super.initState();
    this._fetching();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._context = context;

    return Container(
      alignment: Alignment.topLeft, color: XColors.page,
      child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Container(
          width: 1050, margin: EdgeInsets.all(20), padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: XColors.commonLine, width: 1), borderRadius: BorderRadius.all(Radius.circular(20))),
          child: this._renderSubView()),)
    );
  }

  /// SubView
  Widget _renderSubView(){
    return Column(children: [
      this._renderHeader(),
      Expanded(flex:1, child: this._renderList()),
      this._renderFooter()
    ]);
  }


  Widget _renderList(){
    return XListView(
      // renderHeader: this._renderHeader(),
      // renderFooter: this._renderFooter(),
      itemCount: this._dataList.length,
      itemHeight: this._columnHeight,
      renderItem: (context, index) {
        AccountModel item = this._dataList[index];
        List temp = [item.id, item.account, item.accountName, 'operation'];

        return Container(
          decoration: BoxDecoration(color: (index%2 == 0)? Color.fromRGBO(246, 249, 253, 1) : Colors.white),
          child: Row(children: temp.asMap().entries.map((e) {
            if(e.value == 'operation') {
              return Container(alignment: Alignment.centerLeft, padding: EdgeInsets.only(left:20), height: 68, child: this._renderOperation());
            } else {
              return Container(
                width:this._tableColumnWidth[e.key], alignment: Alignment.centerLeft, height:68, padding: EdgeInsets.only(left: 20),
                child: Text(e.value, maxLines: 2, overflow: TextOverflow.visible, style: TextStyle( height: 1.3, color:Color.fromRGBO(73, 73, 73, 1), fontSize: 15, fontWeight: FontWeight.normal )));
            }
          }).toList()),
        );

      },
    );
  }

  Widget _renderHeader(){
    Widget createButton = widget.listType == AccountListType.ENABLE?
      XButton(title: '创建新账号', onPress: () { this._onChangeToOperatePage(LeftEdgeItem.CREATE_ACCOUNT, {'id':'111'}); }, titleSize: 15, titleColor: XColors.primaryText, color: XColors.primary)
        :
      Container(height: 36,);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      createButton,
      Divider(height: 40, color: XColors.commonLine, thickness: 1),
      Row(children: this._tableHeaderTitles.asMap().entries.map((e) => Container(
        width: this._tableColumnWidth[e.key], alignment: Alignment.centerLeft, height: 68, padding: EdgeInsets.only(left: 20),
        child: Text(e.value, style: TextStyle(color:Color.fromRGBO(86, 105, 141, 1), fontSize: 16, fontWeight: FontWeight.bold ))
      )).toList())
    ]);
  }

  Widget _renderFooter(){
    if(this._dataList?.length == 0) return UIHelper.emptyPage();

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
    if(widget.listType == AccountListType.ENABLE) {
      return Row(children: [
        XButton(title: '修改信息', onPress: (){ this._onChangeToOperatePage(LeftEdgeItem.EDIT_ACCOUNT, {'id':'222'}); }, color: Colors.white, border: true),
        VerticalDivider(width: 15, color: Colors.transparent),
        XButton(title: '修改密码', onPress: (){ this._onChangeToOperatePage(LeftEdgeItem.EDIT_ACCOUNT_PWD, {'id':'333'}); }, color: Colors.white, border: true),
        VerticalDivider(width: 15, color: Colors.transparent),
        XButton(title: '修改角色', onPress: (){ this._onChangeToOperatePage(LeftEdgeItem.EDIT_ACCOUNT_ROLE, {'id':'444'}); }, color: Colors.white, border: true),
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
    String type = widget.listType == AccountListType.ENABLE? '启用列表':'禁用列表';
    RemoteData<AccountListData> res =  await AccountRemoter.getAccountList(pageNum: this._pageNum, pageLimit: this._pageLimit);
    // res = MockData.getAccountList(this._pageNum, this._pageLimit);

    if(res != null && res.statusCode == 200) {
      this._dataList = res.data.list;
      this._pagination = res.pagination;
      setState(() {});
    }
  }



  /// Events
  void _onChangePage(int change){
    this._pageNum += change;
    this._fetching();
  }

  void _onChangeToPage(int page) {
    if(this._pageNum == page) return;
    this._pageNum = page;
    this._fetching();
  }

  void _onChangeToOperatePage(LeftEdgeItem leftEdgeItem, Map params){
    widget.onChangeSubPage(leftEdgeItem, params);
  }

  void _operateDialog(String operate){
    if(operate == 'enable') {
      Tipper.dialog(context: this._context, title: '是否确定启用账号', content: '启用启用启用启用启用', onLeftPress: (){});
    }
    else if(operate == 'forbidden') {
      Tipper.dialog(context: this._context, title: '是否确定停用账号', content: '停用停用停用停用停用', onLeftPress: (){});
    }
  }
}