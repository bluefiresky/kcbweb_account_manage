

import 'package:kcbweb_account_manage/data_models/role_model.dart';

class AccountModel {
  String id;
  String accountID;
  String account;
  String accountName;
  String password;
  String remark;
  RoleModel currentRole;

  AccountModel();

  AccountModel.from(this.id, this.accountID, this.account, this.accountName, this.password, this.remark, this.currentRole);

  AccountModel.fromData(Map data){
    if(data?.isNotEmpty ?? false) {
      this.id = data['id'] ?? '';
      this.accountID = data['accountID'] ?? '';
      this.account = data['account'] ?? '';
      this.accountName = data['accountName'] ?? '';
      this.password = data['password'] ?? '';
      this.remark = data['remark'] ?? '';
      this.currentRole = RoleModel.fromData(data['currentRole']);
    }
  }

  @override
  String toString() {
    return " ## id: $id -- accountID: $accountID -- accountName: $accountName -- password: $password -- remark: $remark -- currentRole :${currentRole.toString()}";
  }
}
