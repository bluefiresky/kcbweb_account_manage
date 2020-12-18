
import 'dart:convert' as convert;

import 'package:flutter/foundation.dart';
import 'package:kcbweb_account_manage/data_models/remote/account_remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote_data.dart';
import 'package:kcbweb_account_manage/remote/fetch_factory.dart';
import 'package:kcbweb_account_manage/data_models/remote/pagination.dart';
import 'package:kcbweb_account_manage/utility/log_helper.dart';

class AccountRemoter {

  static Future<RemoteData<AccountRemoteData>> getAccountList ({@required int pageNum, @required int pageLimit, Map filter }) async {
    RemoteData res = await FetchFactory.post('user/amateur/list/', params: { 'pagination': Pagination(current:pageNum, pageSize:pageLimit).toMap(), 'filter':filter }, version: 'v200');
    // LogHelper.v('999999999 -->> account res -->> ${res.statusCode} -- ${res.message} -- ${res.data}');
    if(res != null)  {
      return RemoteData(res.statusCode, res.message, AccountRemoteData.fromJson(res.data, current: pageNum, pageSize: pageLimit));
    }
    return null;
  }

}