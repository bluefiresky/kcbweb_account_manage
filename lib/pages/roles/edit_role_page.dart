
import 'package:flutter/material.dart';
import 'package:kcbweb_account_manage/common/ui_helper.dart';
import 'package:kcbweb_account_manage/common/widget/x_button.dart';
import 'package:kcbweb_account_manage/common/x_colors.dart';
import 'package:kcbweb_account_manage/data_models/remote/remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote/role_remote_data.dart';
import 'package:kcbweb_account_manage/pages/widget/left_edge_controller.dart';
import 'package:kcbweb_account_manage/pages/widget/x_input_view.dart';
import 'package:kcbweb_account_manage/remote/mock_data.dart';
import 'package:kcbweb_account_manage/remote/role_remoter.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';

class EditRolePage extends StatefulWidget {

  final Map propsParams;
  final Function onChangeSubPage;

  EditRolePage({Key key, this.propsParams, this.onChangeSubPage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => EditRolePageState();
}

class EditRolePageState extends State<EditRolePage> {

  String id;
  RoleModel _roleModel;

  @override
  void initState() {
    super.initState();
    this.id = widget.propsParams['id'];
    this._fetching();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: this._renderSubView());
  }

  Widget _renderBackView(){
    return Container(
      alignment: Alignment.topLeft, margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(color:Colors.white, border: Border.all(width: 1, color: XColors.commonLine), borderRadius: BorderRadius.circular(5)),
      child: Row(children: [
        UIHelper.backButton((){ widget.onChangeSubPage(LeftEdgeItem.ENABLE_ROLES_LIST, null); }),
        VerticalDivider(width: 10, color: Colors.transparent),
        Text('修改角色信息', style: TextStyle(color: Colors.black, fontSize: 16))
      ]),
    );
  }


  /// SubView
  Widget _renderSubView(){
    return Column(children: [this._renderBackView(), Expanded(child: this._renderContent())]);
  }

  Widget _renderContent(){
    return Container(
      width: 1000, margin: EdgeInsets.all(20), padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: XColors.commonLine, width: 1), borderRadius: BorderRadius.circular(20)),
      child: this._renderInputView(),
    );
  }

  Widget _renderInputView(){
    return Column(children: [
      this._renderInputItem('role-name', '角色名称：', this._roleModel?.roleName),
      Divider(height: 15),
      this._renderInputItem('role-desc', '角色描述：', this._roleModel?.roleDesc),
      Divider(height: 66),
      XButton(title: '提交', onPress: () { this._submit(); }, width: 310, height: 54, titleSize: 18, titleColor: XColors.primaryText, color: XColors.primary)
    ]);
  }

  Widget _renderInputItem(String label, String title, String keyword){
    return XInputView(
        title: title, placeholder: '请输入', keyword: keyword,
        onChanged: (String text) { this._onTextChanged(label, text); }
    );
  }

  /// Api
  void _fetching() async {
    RemoteData<RoleModel> res = await RoleRemoter.getRoleDetail(id: this.id);
    res = MockData.getRoleDetail(this.id);
    if(res != null) {
      this._roleModel = res.data;
      setState(() {});
    }
  }


  void _submit() {
    Logger.e( '  88888 submit -->> ${this._roleModel.toString()}');
    // setState(() {});
  }

  /// Events
  void _onTextChanged(String label, String value){
    switch(label) {
      case 'role-name': this._roleModel.roleName = value; break;
      case 'role-desc': this._roleModel.roleDesc = value; break;
    }
  }
}