
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/ui_helper.dart';
import 'package:kcbweb_account_manage/pages/account/account_list_page.dart';
import 'package:kcbweb_account_manage/pages/roles/role_list_page.dart';
import 'package:kcbweb_account_manage/pages/widget/left_edge_controller.dart';
import 'package:kcbweb_account_manage/common/tip_helper.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  LeftEdgeItem _currentPageKey = LeftEdgeItem.ENABLE_ACCOUNT_LIST;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        LeftEdgeController(currentItem: this._currentPageKey, onChangeItem: this._onChangeList),
        Expanded(flex: 1, child:this._renderList())
      ]),
    );
  }


  /// renderSubView
  Widget _renderList(){
    switch(this._currentPageKey) {
      case LeftEdgeItem.ENABLE_ACCOUNT_LIST: return AccountListPage(key: UniqueKey(), listType: AccountListType.ENABLE);
      case LeftEdgeItem.FORBIDDEN_ACCOUNT_LIST: return AccountListPage(key: UniqueKey(), listType: AccountListType.FORBIDDEN);
      case LeftEdgeItem.ENABLE_ROLES_LIST: return RoleListPage(key: UniqueKey(), listType: RoleListType.ENABLE);
      case LeftEdgeItem.FORBIDDEN_ROLES_LIST: return RoleListPage(key: UniqueKey(), listType: RoleListType.FORBIDDEN);
      default: return UIHelper.emptyPage();
    }
  }


  /// Event
  void _onChangeList(LeftEdgeItem leftEdgeItem){
    this._currentPageKey = leftEdgeItem;
    LogHelper.v('111111111111113333 -->> $_currentPageKey');
    setState(() {});
  }
}