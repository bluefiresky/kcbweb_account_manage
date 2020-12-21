
import 'package:kcbweb_account_manage/data_models/remote/account_remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote/pagination.dart';
import 'package:kcbweb_account_manage/data_models/remote/remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote/role_remote_data.dart';

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

  /// --- 角色列表
  static RemoteData<RoleRemoteData> getRoleList (int current, int pageSize){
    int index = 0;
    List list = [];
    List(pageSize).forEach((element) {
      Map item = { 'id':'ID_${index.toString()}', 'roleName':'rn_${index.toString()}', 'roleDesc':'rd_${index.toString()}' };
      index++;
      list.add(item);
    });
    Map mockData = { 'list': list };
    Pagination mockPagination = Pagination(total: 100, current: current, pageSize: pageSize);

    return RemoteData(200, '', RoleRemoteData.fromData(mockData), pagination: mockPagination);
  }

}