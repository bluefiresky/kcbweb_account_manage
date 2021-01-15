
import 'dart:convert' as convert;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:kcbweb_account_manage/data_models/account_model.dart';
import 'package:kcbweb_account_manage/data_models/remote/account_remote_data.dart';
import 'package:kcbweb_account_manage/data_models/remote/remote_data.dart';
import 'package:kcbweb_account_manage/remote/config/fetch_factory.dart';
import 'package:kcbweb_account_manage/data_models/remote/pagination.dart';
import 'package:kcbweb_account_manage/remote/model/supplier-account/api.dart';
import 'package:kcbweb_account_manage/remote/model/supplier-account/model.dart';

import './model/api-helper.dart';



class AccountRemoter {

  static Future<RemoteData<AccountListData>> getAccountList ({@required int pageNum, @required int pageLimit, Map filter }) async {
    // Caller caller = Caller('http', '39.98.209.45', 80, '', 'c4ca4238a0b923820dcc509a6f75849b', '45C8E8E80241E9F863D8ABC750DEAEA2D6F147B3BCB32A066D5E76B6C029E3C9436189F3F5FDE6AB', Random());
    // Future<Tuple<Tuple<String, String>, Pagination<SupplierAccount>>> tuple = getAllSupplierAccountList(caller, offset: pageNum, limit: pageLimit);

    RemoteData res = await FetchFactory.post('user/amateur/list/', params: { 'pagination': Pagination1(current:pageNum, pageSize:pageLimit).toMap(), 'filter':filter }, version: 'v200');
    if(res != null)  {
      return RemoteData(
          res.statusCode, res.message, AccountListData.fromData(res.data),
          pagination: Pagination1(total: 100, current: pageNum, pageSize: pageLimit),
      );
    }
    return null;
  }

  static Future<RemoteData<AccountModel>> getAccountDetail ({@required String id }) async {
    RemoteData res = await FetchFactory.post('user/amateur/list/', params: { 'id':id }, version: 'v200');
    if(res != null)  {
      return RemoteData(
        res.statusCode, res.message, AccountModel.fromData(res.data),
      );
    }
    return null;
  }


}

