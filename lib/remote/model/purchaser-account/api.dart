import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api-helper.dart';
import '../session/api.dart' as session;
import 'model.dart';
import '../role/model.dart';
import '../purchaser/model.dart';
import '../role/api.dart';
import '../purchaser/api.dart';

PurchaserAccount getPurchaserAccountFromJson(Map<String, dynamic> node) {
  final fsmid = BigInt.parse(node['fsmid']);
  final purchaser = BigInt.parse(node['purchaser']['fsmid']);
  final purchaserRef = getPurchaserFromJson(node['purchaser']);
  final account = node['account'];
  final password = node['password'];
  final salt = BigInt.parse(node['salt']);
  final name = node['name'];
  final remark = node['remark'];
  final role = BigInt.parse(node['role']['fsmid']);
  final roleRef = getRoleFromJson(node['role']);
  final secret = node['secret'];
  final initialPasswordUpdated = node['initial-password-updated'];
  final purchaserAccount = PurchaserAccount(fsmid, purchaser, purchaserRef, account, password, salt, name, remark, role, roleRef, secret, initialPasswordUpdated);
  return purchaserAccount;
}

Future<Tuple<Tuple<String, String>, PurchaserAccount>> _getPurchaserAccount(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt _fsmid) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = '';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/purchaser-account/${_fsmid}|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchaser-account/${_fsmid}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    if (_code == 200) {
      return Tuple<Tuple<String, String>, PurchaserAccount>(_tokensOption, getPurchaserAccountFromJson(_respbody['payload']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getPurchaserAccount(_self, _tokensOption, _countdown, _fsmid);
      } on ApiException {
        sleep(const Duration(seconds:1));
        _countdown -= 1;
        return _getPurchaserAccount(_self, _tokensOption, _countdown, _fsmid);
      }
    } else {
      throw ApiException(_code, _respbody['payload']);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, PurchaserAccount>> getPurchaserAccount(Caller _self, BigInt _fsmid) async {
  final _tokensOption = null;
  final _countdown = 2;
  return _getPurchaserAccount(_self, _tokensOption, _countdown, _fsmid);
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaserAccount>>> _getAllPurchaserAccountList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/purchaser-account/all|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchaser-account/all?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaserAccount = getPurchaserAccountFromJson(_e);
        _data.add(purchaserAccount);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaserAccount>>(_tokensOption, Pagination<PurchaserAccount>(_data.cast<PurchaserAccount>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getAllPurchaserAccountList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getAllPurchaserAccountList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaserAccount>>> getAllPurchaserAccountList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getAllPurchaserAccountList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaserAccount>>> _getEnabledPurchaserAccountList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/purchaser-account/enabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchaser-account/enabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaserAccount = getPurchaserAccountFromJson(_e);
        _data.add(purchaserAccount);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaserAccount>>(_tokensOption, Pagination<PurchaserAccount>(_data.cast<PurchaserAccount>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getEnabledPurchaserAccountList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getEnabledPurchaserAccountList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaserAccount>>> getEnabledPurchaserAccountList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getEnabledPurchaserAccountList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaserAccount>>> _getDisabledPurchaserAccountList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/purchaser-account/disabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchaser-account/disabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaserAccount = getPurchaserAccountFromJson(_e);
        _data.add(purchaserAccount);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaserAccount>>(_tokensOption, Pagination<PurchaserAccount>(_data.cast<PurchaserAccount>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDisabledPurchaserAccountList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getDisabledPurchaserAccountList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaserAccount>>> getDisabledPurchaserAccountList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getDisabledPurchaserAccountList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}
