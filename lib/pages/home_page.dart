
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/ui_helper.dart';
import 'package:kcbweb_account_manage/pages/account/account_list_page.dart';
import 'package:kcbweb_account_manage/pages/account/edit_account_page.dart';
import 'package:kcbweb_account_manage/pages/account/edit_account_pwd_page.dart';
import 'package:kcbweb_account_manage/pages/account/edit_account_role_page.dart';
import 'package:kcbweb_account_manage/pages/roles/edit_role_page.dart';
import 'package:kcbweb_account_manage/pages/roles/role_list_page.dart';
import 'package:kcbweb_account_manage/pages/widget/left_edge_controller.dart';
import 'package:kcbweb_account_manage/common/tip_helper.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';

import 'account/create_account_page.dart';
import 'roles/create_role_page.dart';
import 'widget/left_edge_controller.dart';
import 'widget/left_edge_controller.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  LeftEdgeItem _currentPageKey = LeftEdgeItem.CREATE_ACCOUNT;
  Map _propsParams = {};

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
      // 账户Pages
      case LeftEdgeItem.ENABLE_ACCOUNT_LIST: return AccountListPage(key: UniqueKey(), listType: AccountListType.ENABLE, onChangeSubPage: this._onChangeToOperatePage,);
      case LeftEdgeItem.FORBIDDEN_ACCOUNT_LIST: return AccountListPage(key: UniqueKey(), listType: AccountListType.FORBIDDEN, onChangeSubPage: this._onChangeToOperatePage);
      case LeftEdgeItem.CREATE_ACCOUNT: return CreateAccountPage(propsParams: this._propsParams, onChangeSubPage: this._onChangeToOperatePage); break;
      case LeftEdgeItem.EDIT_ACCOUNT: return EditAccountPage(propsParams: this._propsParams, onChangeSubPage: this._onChangeToOperatePage); break;
      case LeftEdgeItem.EDIT_ACCOUNT_PWD: return EditAccountPwdPage(propsParams: this._propsParams, onChangeSubPage: this._onChangeToOperatePage); break;
      case LeftEdgeItem.EDIT_ACCOUNT_ROLE: return EditAccountRolePage(propsParams: this._propsParams, onChangeSubPage: this._onChangeToOperatePage); break;
      // 角色Pages
      case LeftEdgeItem.ENABLE_ROLES_LIST: return RoleListPage(key: UniqueKey(), listType: RoleListType.ENABLE, onChangeSubPage: this._onChangeToOperatePage);
      case LeftEdgeItem.FORBIDDEN_ROLES_LIST: return RoleListPage(key: UniqueKey(), listType: RoleListType.FORBIDDEN, onChangeSubPage: this._onChangeToOperatePage);
      case LeftEdgeItem.CREATE_ROLE: return CreateRolePage(propsParams: this._propsParams, onChangeSubPage: this._onChangeToOperatePage); break;
      case LeftEdgeItem.EDIT_ROLE: return EditRolePage(propsParams: this._propsParams, onChangeSubPage: this._onChangeToOperatePage); break;

      default: return UIHelper.emptyPage();
    }
  }


  /// Event
  void _onChangeList(LeftEdgeItem leftEdgeItem){
    this._currentPageKey = leftEdgeItem;
    Logger.d(' 000000 _onChangeList -->> $_currentPageKey');
    setState(() {});
  }

  void _onChangeToOperatePage(LeftEdgeItem leftEdgeItem, Map params) {
    this._currentPageKey = leftEdgeItem;
    this._propsParams = params;
    Logger.d(' 000000 _onChangeToOperatePage -->> $_currentPageKey -- propsParams -->> $_propsParams');
    setState(() {});
  }
}