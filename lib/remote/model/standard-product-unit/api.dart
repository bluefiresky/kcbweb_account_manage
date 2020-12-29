import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api-helper.dart';
import '../session/api.dart' as session;
import 'model.dart';
import '../feature/model.dart';
import '../category/model.dart';
import '../brand/model.dart';
import '../feature/api.dart';
import '../category/api.dart';
import '../brand/api.dart';

StandardProductUnit getStandardProductUnitFromJson(Map<String, dynamic> node) {
  final fsmid = BigInt.parse(node['fsmid']);
  final code = node['code'];
  final name = node['name'];
  final brand = BigInt.parse(node['brand']['fsmid']);
  final brandRef = getBrandFromJson(node['brand']);
  final category = BigInt.parse(node['category']['fsmid']);
  final categoryRef = getCategoryFromJson(node['category']);
  final features = List<BigInt>.from(node['features'].map((i) => BigInt.parse(i['fsmid'])));
  final featuresRefs = List<Feature>.from(node['features'].map((i) => getFeatureFromJson(i)));
  final specificationGroups = node['specification-groups'].map<String, Map<String, String>>((k0, v0) => MapEntry<String, Map<String, String>>(k0, v0.map<String, String>((k1, v1) => MapEntry<String, String>(k1, v1))));
  final standardProductUnit = StandardProductUnit(fsmid, code, name, brand, brandRef, category, categoryRef, features, featuresRefs, specificationGroups);
  return standardProductUnit;
}

Future<Tuple<Tuple<String, String>, StandardProductUnit>> _getStandardProductUnit(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt _fsmid) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = '';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/standard-product-unit/${_fsmid}|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/standard-product-unit/${_fsmid}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    if (_code == 200) {
      return Tuple<Tuple<String, String>, StandardProductUnit>(_tokensOption, getStandardProductUnitFromJson(_respbody['payload']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getStandardProductUnit(_self, _tokensOption, _countdown, _fsmid);
      } on ApiException {
        sleep(const Duration(seconds:1));
        _countdown -= 1;
        return _getStandardProductUnit(_self, _tokensOption, _countdown, _fsmid);
      }
    } else {
      throw ApiException(_code, _respbody['payload']);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, StandardProductUnit>> getStandardProductUnit(Caller _self, BigInt _fsmid) async {
  final _tokensOption = null;
  final _countdown = 2;
  return _getStandardProductUnit(_self, _tokensOption, _countdown, _fsmid);
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> _getAllStandardProductUnitList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/standard-product-unit/all|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/standard-product-unit/all?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final standardProductUnit = getStandardProductUnitFromJson(_e);
        _data.add(standardProductUnit);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>(_tokensOption, Pagination<StandardProductUnit>(_data.cast<StandardProductUnit>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getAllStandardProductUnitList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getAllStandardProductUnitList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> getAllStandardProductUnitList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getAllStandardProductUnitList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> _getEnabledStandardProductUnitList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/standard-product-unit/enabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/standard-product-unit/enabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final standardProductUnit = getStandardProductUnitFromJson(_e);
        _data.add(standardProductUnit);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>(_tokensOption, Pagination<StandardProductUnit>(_data.cast<StandardProductUnit>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getEnabledStandardProductUnitList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getEnabledStandardProductUnitList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> getEnabledStandardProductUnitList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getEnabledStandardProductUnitList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> _getDisabledStandardProductUnitList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/standard-product-unit/disabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/standard-product-unit/disabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final standardProductUnit = getStandardProductUnitFromJson(_e);
        _data.add(standardProductUnit);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>(_tokensOption, Pagination<StandardProductUnit>(_data.cast<StandardProductUnit>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDisabledStandardProductUnitList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getDisabledStandardProductUnitList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> getDisabledStandardProductUnitList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getDisabledStandardProductUnitList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> _getAllStandardProductUnitListByBrand(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/brand/${rid}/standard-product-unit/all|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/brand/${rid}/standard-product-unit/all?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final standardProductUnit = getStandardProductUnitFromJson(_e);
        _data.add(standardProductUnit);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>(_tokensOption, Pagination<StandardProductUnit>(_data.cast<StandardProductUnit>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getAllStandardProductUnitListByBrand(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getAllStandardProductUnitListByBrand(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> getAllStandardProductUnitListByBrand(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getAllStandardProductUnitListByBrand(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> _getEnabledStandardProductUnitListByBrand(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/brand/${rid}/standard-product-unit/enabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/brand/${rid}/standard-product-unit/enabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final standardProductUnit = getStandardProductUnitFromJson(_e);
        _data.add(standardProductUnit);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>(_tokensOption, Pagination<StandardProductUnit>(_data.cast<StandardProductUnit>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getEnabledStandardProductUnitListByBrand(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getEnabledStandardProductUnitListByBrand(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> getEnabledStandardProductUnitListByBrand(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getEnabledStandardProductUnitListByBrand(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> _getDisabledStandardProductUnitListByBrand(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/brand/${rid}/standard-product-unit/disabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/brand/${rid}/standard-product-unit/disabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final standardProductUnit = getStandardProductUnitFromJson(_e);
        _data.add(standardProductUnit);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>(_tokensOption, Pagination<StandardProductUnit>(_data.cast<StandardProductUnit>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDisabledStandardProductUnitListByBrand(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getDisabledStandardProductUnitListByBrand(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> getDisabledStandardProductUnitListByBrand(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getDisabledStandardProductUnitListByBrand(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> _getAllStandardProductUnitListByCategory(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/category/${rid}/standard-product-unit/all|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/category/${rid}/standard-product-unit/all?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final standardProductUnit = getStandardProductUnitFromJson(_e);
        _data.add(standardProductUnit);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>(_tokensOption, Pagination<StandardProductUnit>(_data.cast<StandardProductUnit>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getAllStandardProductUnitListByCategory(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getAllStandardProductUnitListByCategory(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> getAllStandardProductUnitListByCategory(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getAllStandardProductUnitListByCategory(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> _getEnabledStandardProductUnitListByCategory(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/category/${rid}/standard-product-unit/enabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/category/${rid}/standard-product-unit/enabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final standardProductUnit = getStandardProductUnitFromJson(_e);
        _data.add(standardProductUnit);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>(_tokensOption, Pagination<StandardProductUnit>(_data.cast<StandardProductUnit>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getEnabledStandardProductUnitListByCategory(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getEnabledStandardProductUnitListByCategory(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> getEnabledStandardProductUnitListByCategory(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getEnabledStandardProductUnitListByCategory(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> _getDisabledStandardProductUnitListByCategory(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/category/${rid}/standard-product-unit/disabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/category/${rid}/standard-product-unit/disabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final standardProductUnit = getStandardProductUnitFromJson(_e);
        _data.add(standardProductUnit);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>(_tokensOption, Pagination<StandardProductUnit>(_data.cast<StandardProductUnit>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDisabledStandardProductUnitListByCategory(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getDisabledStandardProductUnitListByCategory(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<StandardProductUnit>>> getDisabledStandardProductUnitListByCategory(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getDisabledStandardProductUnitListByCategory(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}
