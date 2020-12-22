
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/ui_helper.dart';
import 'package:kcbweb_account_manage/common/widget/x_button.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';
import 'package:kcbweb_account_manage/data_models/remote/account_remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote/remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote/role_remote_data.dart';
import 'package:kcbweb_account_manage/pages/widget/left_edge_controller.dart';
import 'package:kcbweb_account_manage/pages/widget/x_input_view.dart';
import 'package:kcbweb_account_manage/remote/account_remoter.dart';
import 'package:kcbweb_account_manage/remote/mock_data.dart';
import 'package:kcbweb_account_manage/remote/role_remoter.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';

class EditAccountRolePage extends StatefulWidget {

  final Map propsParams;
  final Function onChangeSubPage;

  EditAccountRolePage({Key key, this.propsParams, this.onChangeSubPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EditAccountRolePageState();
}

class EditAccountRolePageState extends State<EditAccountRolePage> {

  String id;

  List<RoleModel> roleList;
  AccountModel _accountDetail;

  double titleW = 120;
  double inputW = 500;


  @override
  void initState() {
    super.initState();
    this._fetching();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topLeft, color: XColors.page,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            this._renderBackView(),
            Expanded(child: this._renderSubView())
          ],
        )
    );
  }


  Widget _renderBackView(){
    return Container(
        alignment: Alignment.topLeft, margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: BoxDecoration(color:Colors.white, border: Border.all(width: 1, color: XColors.commonLine), borderRadius: BorderRadius.circular(5)),
        child: Row(children: [
          UIHelper.backButton((){ widget.onChangeSubPage(LeftEdgeItem.ENABLE_ACCOUNT_LIST, null); }),
          VerticalDivider(width: 10, color: Colors.transparent),
          Text('修改角色', style: TextStyle(color: Colors.black, fontSize: 16))
        ]),
    );
  }

  /// SubView
  Widget _renderSubView(){
    return Container(
      alignment: Alignment.topLeft,
      margin:EdgeInsets.all(20), padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color:Colors.white, border: Border.all(width: 1, color: XColors.commonLine), borderRadius: BorderRadius.circular(20)),
      child: this._renderInputView(),
    );
  }


  Widget _renderInputView(){
    return Column(
      children: [
        XInputView(title: '账号', keyword: this._accountDetail?.accountID, placeholder: '请输入', enabled: false, obscure: false,),
        Divider(height: 15, color: Colors.transparent),
        this._renderDropdownRow('current-role', title: '角色：', value: this._accountDetail?.currentRole?.id),
        Divider(height: 66, color: Colors.transparent),
        XButton(title: '提交', onPress: () { this._submit(); }, width: 310, height: 54, titleSize: 18, titleColor: XColors.primaryText, color: XColors.primary),
      ],
    );
  }


  Widget _renderDropdownRow(String label, { String title, var value}){
    List items = this.roleList?.map((e) {
      return DropdownMenuItem(child: Text(e.roleName, style: TextStyle(height: 1.3, fontSize: 16)), value:e.id);
    })?.toList();

    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: this.titleW, alignment: Alignment.centerRight, padding: EdgeInsets.only(right: 10),
          child: Text(title, style: TextStyle(fontSize: 18, color: XColors.mainText),)
      ),
      Container(
        width: this.inputW,
        child: DropdownButtonFormField(
          isExpanded: true, decoration: InputDecoration(labelText: '请选择角色', border: OutlineInputBorder()),
          items: items,
          value: value,
          onChanged: (value) {
            List resultList = this.roleList.where((element) => (element.id == value)).toList();
            if(this._accountDetail?.currentRole != null) {
              this._accountDetail.currentRole = resultList.first;
              setState(() {});
            }
          },
        ),
      )
    ]);
  }

  /// Api
  void _fetching() async {
    this._accountDetail = AccountModel();

    RemoteData<RoleListData> roleRes = await RoleRemoter.getRoleList(pageNum: 1, pageLimit: 10);
    roleRes = MockData.getRoleList(1, 10);
    this.roleList = roleRes?.data?.list ?? [];

    RemoteData<AccountModel> accountRes = await AccountRemoter.getAccountDetail(id: '111');
    accountRes = MockData.getAccountDetail('222', roleModel: (this.roleList?.length ?? 0) > 0? this.roleList.first:null);
    this._accountDetail = accountRes.data;

    setState(() {});

  }

  /// Events
  void _submit(){
    Logger.i(" 88888888 -->> ${this._accountDetail.toString()}");
  }
}