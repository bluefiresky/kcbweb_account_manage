
import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:kcbweb_account_manage/data_models/remote/account_remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote/remote_data.dart';
import 'package:kcbweb_account_manage/remote/fetch_factory.dart';
import 'package:kcbweb_account_manage/data_models/remote/pagination.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';

class AccountRemoter {

  static Future<RemoteData<AccountListData>> getAccountList ({@required int pageNum, @required int pageLimit, Map filter }) async {
    RemoteData res = await FetchFactory.post('user/amateur/list/', params: { 'pagination': Pagination(current:pageNum, pageSize:pageLimit).toMap(), 'filter':filter }, version: 'v200');
    // LogHelper.v('999999999 -->> account res -->> ${res.statusCode} -- ${res.message} -- ${res.data}');
    if(res != null)  {
      return RemoteData(
          res.statusCode, res.message, AccountListData.fromData(res.data),
          pagination: Pagination(total: 100, current: pageNum, pageSize: pageLimit),
      );
    }
    return null;
  }

  static Future<RemoteData<AccountModel>> getAccountDetail ({@required String id }) async {
    RemoteData res = await FetchFactory.post('user/amateur/list/', params: { 'id':id }, version: 'v200');
    // LogHelper.v('999999999 -->> account res -->> ${res.statusCode} -- ${res.message} -- ${res.data}');
    if(res != null)  {
      return RemoteData(
        res.statusCode, res.message, AccountModel.fromData(res.data),
      );
    }
    return null;
  }


}

