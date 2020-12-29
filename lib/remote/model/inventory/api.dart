import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api-helper.dart';
import '../session/api.dart' as session;
import 'model.dart';
import '../stock-keeping-unit/model.dart';
import '../supplier/model.dart';
import '../stock-keeping-unit/api.dart';
import '../supplier/api.dart';

Inventory getInventoryFromJson(Map<String, dynamic> node) {
  final fsmid = BigInt.parse(node['fsmid']);
  final supplier = BigInt.parse(node['supplier']['fsmid']);
  final supplierRef = getSupplierFromJson(node['supplier']);
  final sku = BigInt.parse(node['sku']['fsmid']);
  final skuRef = getStockKeepingUnitFromJson(node['sku']);
  final quantity = node['quantity'];
  final unit = node['unit'];
  final inventory = Inventory(fsmid, supplier, supplierRef, sku, skuRef, quantity, unit);
  return inventory;
}

Future<Tuple<Tuple<String, String>, Inventory>> _getInventory(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt _fsmid) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = '';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/inventory/${_fsmid}|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/inventory/${_fsmid}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    if (_code == 200) {
      return Tuple<Tuple<String, String>, Inventory>(_tokensOption, getInventoryFromJson(_respbody['payload']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getInventory(_self, _tokensOption, _countdown, _fsmid);
      } on ApiException {
        sleep(const Duration(seconds:1));
        _countdown -= 1;
        return _getInventory(_self, _tokensOption, _countdown, _fsmid);
      }
    } else {
      throw ApiException(_code, _respbody['payload']);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Inventory>> getInventory(Caller _self, BigInt _fsmid) async {
  final _tokensOption = null;
  final _countdown = 2;
  return _getInventory(_self, _tokensOption, _countdown, _fsmid);
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> _getAllInventoryList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/inventory/all|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/inventory/all?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final inventory = getInventoryFromJson(_e);
        _data.add(inventory);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<Inventory>>(_tokensOption, Pagination<Inventory>(_data.cast<Inventory>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getAllInventoryList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getAllInventoryList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> getAllInventoryList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getAllInventoryList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> _getOnShelfInventoryList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/inventory/on-shelf|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/inventory/on-shelf?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final inventory = getInventoryFromJson(_e);
        _data.add(inventory);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<Inventory>>(_tokensOption, Pagination<Inventory>(_data.cast<Inventory>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getOnShelfInventoryList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getOnShelfInventoryList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> getOnShelfInventoryList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getOnShelfInventoryList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> _getOffShelfInventoryList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/inventory/off-shelf|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/inventory/off-shelf?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final inventory = getInventoryFromJson(_e);
        _data.add(inventory);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<Inventory>>(_tokensOption, Pagination<Inventory>(_data.cast<Inventory>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getOffShelfInventoryList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getOffShelfInventoryList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> getOffShelfInventoryList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getOffShelfInventoryList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> _getDisabledInventoryList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/inventory/disabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/inventory/disabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final inventory = getInventoryFromJson(_e);
        _data.add(inventory);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<Inventory>>(_tokensOption, Pagination<Inventory>(_data.cast<Inventory>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDisabledInventoryList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getDisabledInventoryList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> getDisabledInventoryList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getDisabledInventoryList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> _getAllInventoryListByStockKeepingUnit(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/stock-keeping-unit/${rid}/inventory/all|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/stock-keeping-unit/${rid}/inventory/all?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final inventory = getInventoryFromJson(_e);
        _data.add(inventory);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<Inventory>>(_tokensOption, Pagination<Inventory>(_data.cast<Inventory>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getAllInventoryListByStockKeepingUnit(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getAllInventoryListByStockKeepingUnit(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> getAllInventoryListByStockKeepingUnit(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getAllInventoryListByStockKeepingUnit(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> _getOnShelfInventoryListByStockKeepingUnit(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/stock-keeping-unit/${rid}/inventory/on-shelf|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/stock-keeping-unit/${rid}/inventory/on-shelf?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final inventory = getInventoryFromJson(_e);
        _data.add(inventory);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<Inventory>>(_tokensOption, Pagination<Inventory>(_data.cast<Inventory>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getOnShelfInventoryListByStockKeepingUnit(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getOnShelfInventoryListByStockKeepingUnit(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> getOnShelfInventoryListByStockKeepingUnit(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getOnShelfInventoryListByStockKeepingUnit(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> _getOffShelfInventoryListByStockKeepingUnit(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/stock-keeping-unit/${rid}/inventory/off-shelf|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/stock-keeping-unit/${rid}/inventory/off-shelf?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final inventory = getInventoryFromJson(_e);
        _data.add(inventory);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<Inventory>>(_tokensOption, Pagination<Inventory>(_data.cast<Inventory>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getOffShelfInventoryListByStockKeepingUnit(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getOffShelfInventoryListByStockKeepingUnit(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> getOffShelfInventoryListByStockKeepingUnit(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getOffShelfInventoryListByStockKeepingUnit(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> _getDisabledInventoryListByStockKeepingUnit(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/stock-keeping-unit/${rid}/inventory/disabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/stock-keeping-unit/${rid}/inventory/disabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final inventory = getInventoryFromJson(_e);
        _data.add(inventory);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<Inventory>>(_tokensOption, Pagination<Inventory>(_data.cast<Inventory>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDisabledInventoryListByStockKeepingUnit(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getDisabledInventoryListByStockKeepingUnit(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<Inventory>>> getDisabledInventoryListByStockKeepingUnit(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getDisabledInventoryListByStockKeepingUnit(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}
