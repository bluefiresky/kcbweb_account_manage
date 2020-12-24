
import 'package:kcbweb_account_manage/data_models/account_model.dart';
import 'package:kcbweb_account_manage/data_models/auth_model.dart';
import 'package:kcbweb_account_manage/data_models/remote/account_remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote/pagination.dart';
import 'package:kcbweb_account_manage/data_models/remote/remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote/role_remote_data.dart';
import 'package:kcbweb_account_manage/data_models/role_model.dart';



class MockData {

  /// --- 账号列表
  static RemoteData<AccountListData> getAccountList(int current, int pageSize){
    int index = 0;
    Map mockData = { 'list':List(pageSize).map((e){
      Map item = { 'id':'ID-${index}', 'account':'Account-${index}', 'accountName':'AccountName-${index}' };
      index++;
      return item;
    }).toList() };
    Pagination mockPagination = Pagination(total: 100, current: current, pageSize: pageSize);

    return RemoteData(200, '', AccountListData.fromData(mockData), pagination: mockPagination);
  }

  static RemoteData<AccountModel> getAccountDetail(String id, { RoleModel roleModel }) {
    roleModel ??= RoleModel.from('role-id-$id', 'role-roleName-$id', 'role-roleDesc-$id');
    return RemoteData(
        200,
        'message111',
        AccountModel.from(
            'id000', 'accountID-$id', 'account-$id', 'accountName-$id', 'password-$id', 'remark-$id',
            roleModel,
        )
    );
  }

  /// --- 角色列表
  static RemoteData<RoleListData> getRoleList (int current, int pageSize){
    int index = 0;
    List list = [];
    List(pageSize).forEach((element) {
      Map item = { 'id':'ID_${index.toString()}', 'roleName':'rn_${index.toString()}', 'roleDesc':'rd_${index.toString()}' };
      index++;
      list.add(item);
    });
    Map mockData = { 'list': list };
    Pagination mockPagination = Pagination(total: 100, current: current, pageSize: pageSize);

    return RemoteData(200, '', RoleListData.fromData(mockData), pagination: mockPagination);
  }

  /// -- 角色详情
  static RemoteData<RoleModel> getRoleDetail(String id){
    return RemoteData(200, '', RoleModel.from('000-$id', 'roleName-$id', 'roleDesc-$id'));
  }


  // -- 用户登录成功数据
  static RemoteData<AuthModel> login(String account, String password){
    return RemoteData(200, '', AuthModel('000001-$account', account, 'token-$password-89798w7er98q7we89r7q8w9e'));
  }
}