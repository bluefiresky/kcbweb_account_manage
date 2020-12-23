
import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:kcbweb_account_manage/data_models/remote/remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote/role_remote_data.dart';
import 'package:kcbweb_account_manage/data_models/role_model.dart';
import 'package:kcbweb_account_manage/remote/config/fetch_factory.dart';
import 'package:kcbweb_account_manage/data_models/remote/pagination.dart';


class RoleRemoter {

  static Future<RemoteData<RoleListData>> getRoleList ({@required int pageNum, @required int pageLimit, Map filter }) async {
    RemoteData res = await FetchFactory.post('user/amateur/list/', params: { 'pagination': Pagination(current:pageNum, pageSize:pageLimit).toMap(), 'filter':filter }, version: 'v200');
    // LogHelper.v('999999999 -->> account res -->> ${res.statusCode} -- ${res.message} -- ${res.data}');
    if(res != null)  {
      return RemoteData(
          res.statusCode, res.message, RoleListData.fromData(res.data),
          pagination: Pagination(total: 100, current: pageNum, pageSize: pageLimit),
      );
    }
    return null;
  }

  static Future<RemoteData<RoleModel>> getRoleDetail({@required String id}) async {
    RemoteData res = await FetchFactory.post('', params: { 'id': id }, version: 'v200');
    if(res != null) {
      return RemoteData(res.statusCode, res.message, RoleModel.fromData(res.data));
    }
    return null;
  }

}

