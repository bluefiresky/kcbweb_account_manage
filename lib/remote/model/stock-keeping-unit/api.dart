import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api-helper.dart';
import '../session/api.dart' as session;
import 'model.dart';
import '../standard-product-unit/model.dart';
import '../standard-product-unit/api.dart';

StockKeepingUnit getStockKeepingUnitFromJson(Map<String, dynamic> node) {
  final fsmid = BigInt.parse(node['fsmid']);
  final code = node['code'];
  final name = node['name'];
  final standardProductUnit = BigInt.parse(node['standard-product-unit']['fsmid']);
  final standardProductUnitRef = getStandardProductUnitFromJson(node['standard-product-unit']);
  final features = node['features'].map<String, String>((k0, v0) => MapEntry<String, String>(k0, v0));
  final mainMediaResources = List<String>.from(node['main-media-resources'].map((i0) => i0));
  final detailMediaResources = List<String>.from(node['detail-media-resources'].map((i0) => i0));
  final stockKeepingUnit = StockKeepingUnit(fsmid, code, name, standardProductUnit, standardProductUnitRef, features, mainMediaResources, detailMediaResources);
  return stockKeepingUnit;
}

Future<Tuple<Tuple<String, String>, StockKeepingUnit>> _getStockKeepingUnit(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt _fsmid) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = '';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/stock-keeping-unit/${_fsmid}|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/stock-keeping-unit/${_fsmid}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    if (_code == 200) {
      return Tuple<Tuple<String, String>, StockKeepingUnit>(_tokensOption, getStockKeepingUnitFromJson(_respbody['payload']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getStockKeepingUnit(_self, _tokensOption, _countdown, _fsmid);
      } on ApiException {
        sleep(const Duration(seconds:1));
        _countdown -= 1;
        return _getStockKeepingUnit(_self, _tokensOption, _countdown, _fsmid);
      }
    } else {
      throw ApiException(_code, _respbody['payload']);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, StockKeepingUnit>> getStockKeepingUnit(Caller _self, BigInt _fsmid) async {
  final _tokensOption = null;
  final _countdown = 2;
  return _getStockKeepingUnit(_self, _tokensOption, _countdown, _fsmid);
}

Future<Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>> _getAllStockKeepingUnitList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/stock-keeping-unit/all|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/stock-keeping-unit/all?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final stockKeepingUnit = getStockKeepingUnitFromJson(_e);
        _data.add(stockKeepingUnit);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>(_tokensOption, Pagination<StockKeepingUnit>(_data.cast<StockKeepingUnit>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getAllStockKeepingUnitList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getAllStockKeepingUnitList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>> getAllStockKeepingUnitList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getAllStockKeepingUnitList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>> _getEnabledStockKeepingUnitList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/stock-keeping-unit/enabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/stock-keeping-unit/enabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final stockKeepingUnit = getStockKeepingUnitFromJson(_e);
        _data.add(stockKeepingUnit);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>(_tokensOption, Pagination<StockKeepingUnit>(_data.cast<StockKeepingUnit>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getEnabledStockKeepingUnitList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getEnabledStockKeepingUnitList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>> getEnabledStockKeepingUnitList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getEnabledStockKeepingUnitList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>> _getDisabledStockKeepingUnitList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/stock-keeping-unit/disabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/stock-keeping-unit/disabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final stockKeepingUnit = getStockKeepingUnitFromJson(_e);
        _data.add(stockKeepingUnit);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>(_tokensOption, Pagination<StockKeepingUnit>(_data.cast<StockKeepingUnit>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDisabledStockKeepingUnitList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getDisabledStockKeepingUnitList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>> getDisabledStockKeepingUnitList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getDisabledStockKeepingUnitList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>> _getAllStockKeepingUnitListByStandardProductUnit(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/standard-product-unit/${rid}/stock-keeping-unit/all|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/standard-product-unit/${rid}/stock-keeping-unit/all?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final stockKeepingUnit = getStockKeepingUnitFromJson(_e);
        _data.add(stockKeepingUnit);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>(_tokensOption, Pagination<StockKeepingUnit>(_data.cast<StockKeepingUnit>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getAllStockKeepingUnitListByStandardProductUnit(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getAllStockKeepingUnitListByStandardProductUnit(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>> getAllStockKeepingUnitListByStandardProductUnit(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getAllStockKeepingUnitListByStandardProductUnit(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>> _getEnabledStockKeepingUnitListByStandardProductUnit(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/standard-product-unit/${rid}/stock-keeping-unit/enabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/standard-product-unit/${rid}/stock-keeping-unit/enabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final stockKeepingUnit = getStockKeepingUnitFromJson(_e);
        _data.add(stockKeepingUnit);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>(_tokensOption, Pagination<StockKeepingUnit>(_data.cast<StockKeepingUnit>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getEnabledStockKeepingUnitListByStandardProductUnit(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getEnabledStockKeepingUnitListByStandardProductUnit(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>> getEnabledStockKeepingUnitListByStandardProductUnit(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getEnabledStockKeepingUnitListByStandardProductUnit(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>> _getDisabledStockKeepingUnitListByStandardProductUnit(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/standard-product-unit/${rid}/stock-keeping-unit/disabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/standard-product-unit/${rid}/stock-keeping-unit/disabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final stockKeepingUnit = getStockKeepingUnitFromJson(_e);
        _data.add(stockKeepingUnit);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>(_tokensOption, Pagination<StockKeepingUnit>(_data.cast<StockKeepingUnit>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDisabledStockKeepingUnitListByStandardProductUnit(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getDisabledStockKeepingUnitListByStandardProductUnit(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<StockKeepingUnit>>> getDisabledStockKeepingUnitListByStandardProductUnit(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getDisabledStockKeepingUnitListByStandardProductUnit(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}
