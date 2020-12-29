import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api-helper.dart';
import '../session/api.dart' as session;
import 'model.dart';
import '../role/model.dart';
import '../role/api.dart';

MyOperator getMyOperatorFromJson(Map<String, dynamic> node) {
  final fsmid = BigInt.parse(node['fsmid']);
  final account = node['account'];
  final password = node['password'];
  final salt = BigInt.parse(node['salt']);
  final name = node['name'];
  final remark = node['remark'];
  final role = BigInt.parse(node['role']['fsmid']);
  final roleRef = getRoleFromJson(node['role']);
  final secret = node['secret'];
  final myOperator = MyOperator(fsmid, account, password, salt, name, remark, role, roleRef, secret);
  return myOperator;
}

Future<Tuple<Tuple<String, String>, MyOperator>> _getMyOperator(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt _fsmid) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = '';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/operator/${_fsmid}|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/operator/${_fsmid}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    if (_code == 200) {
      return Tuple<Tuple<String, String>, MyOperator>(_tokensOption, getMyOperatorFromJson(_respbody['payload']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getMyOperator(_self, _tokensOption, _countdown, _fsmid);
      } on ApiException {
        sleep(const Duration(seconds:1));
        _countdown -= 1;
        return _getMyOperator(_self, _tokensOption, _countdown, _fsmid);
      }
    } else {
      throw ApiException(_code, _respbody['payload']);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, MyOperator>> getMyOperator(Caller _self, BigInt _fsmid) async {
  final _tokensOption = null;
  final _countdown = 2;
  return _getMyOperator(_self, _tokensOption, _countdown, _fsmid);
}

Future<Tuple<Tuple<String, String>, Pagination<MyOperator>>> _getAllOperatorList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/operator/all|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/operator/all?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final myOperator = getMyOperatorFromJson(_e);
        _data.add(myOperator);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<MyOperator>>(_tokensOption, Pagination<MyOperator>(_data.cast<MyOperator>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getAllOperatorList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getAllOperatorList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<MyOperator>>> getAllOperatorList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getAllOperatorList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<MyOperator>>> _getEnabledOperatorList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/operator/enabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/operator/enabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final myOperator = getMyOperatorFromJson(_e);
        _data.add(myOperator);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<MyOperator>>(_tokensOption, Pagination<MyOperator>(_data.cast<MyOperator>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getEnabledOperatorList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getEnabledOperatorList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<MyOperator>>> getEnabledOperatorList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getEnabledOperatorList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<MyOperator>>> _getDisabledOperatorList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/operator/disabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/operator/disabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final myOperator = getMyOperatorFromJson(_e);
        _data.add(myOperator);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<MyOperator>>(_tokensOption, Pagination<MyOperator>(_data.cast<MyOperator>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDisabledOperatorList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getDisabledOperatorList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<MyOperator>>> getDisabledOperatorList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getDisabledOperatorList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<MyOperator>>> _getAllOperatorListByRole(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/role/${rid}/operator/all|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/role/${rid}/operator/all?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final myOperator = getMyOperatorFromJson(_e);
        _data.add(myOperator);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<MyOperator>>(_tokensOption, Pagination<MyOperator>(_data.cast<MyOperator>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getAllOperatorListByRole(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getAllOperatorListByRole(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<MyOperator>>> getAllOperatorListByRole(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getAllOperatorListByRole(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<MyOperator>>> _getEnabledOperatorListByRole(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/role/${rid}/operator/enabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/role/${rid}/operator/enabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final myOperator = getMyOperatorFromJson(_e);
        _data.add(myOperator);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<MyOperator>>(_tokensOption, Pagination<MyOperator>(_data.cast<MyOperator>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getEnabledOperatorListByRole(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getEnabledOperatorListByRole(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<MyOperator>>> getEnabledOperatorListByRole(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getEnabledOperatorListByRole(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<MyOperator>>> _getDisabledOperatorListByRole(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt rid, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/role/${rid}/operator/disabled|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/role/${rid}/operator/disabled?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final myOperator = getMyOperatorFromJson(_e);
        _data.add(myOperator);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<MyOperator>>(_tokensOption, Pagination<MyOperator>(_data.cast<MyOperator>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDisabledOperatorListByRole(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getDisabledOperatorListByRole(_self, _tokensOption, _countdown - 1, rid, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<MyOperator>>> getDisabledOperatorListByRole(Caller _self, BigInt rid, {int offset = 0, int limit = 10}) async {
  return _getDisabledOperatorListByRole(_self, Tuple<String, String>(null, null), 2, rid, offset: offset, limit: limit);
}

// begin create
Future<Tuple<Tuple<String, String>, BigInt>> _create(Caller _self, Tuple<String, String> _tokensOption, int _countdown, String account, String password, BigInt salt, String name, String remark, BigInt role) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'account': account, 'password': password, 'salt': salt.toString(), 'name': name, 'remark': remark, 'role': role.toString()});
  final _signbody = 'account=$account&name=$name&password=$password&remark=$remark&role=$role&salt=$salt';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/operator/create|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/operator/create', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    if (_code == 200) {
      return Tuple<Tuple<String, String>, BigInt>(_tokensOption, BigInt.parse(_respbody['payload']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _create(_self, _tokensOption, _countdown, account, password, salt, name, remark, role);
      } on ApiException {
        sleep(const Duration(seconds:1));
        _countdown -= 1;
        return _create(_self, _tokensOption, _countdown, account, password, salt, name, remark, role);
      }
    } else {
      throw ApiException(_code, _respbody['payload']);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, BigInt>> create(Caller _self, String account, String password, BigInt salt, String name, String remark, BigInt role) async {
  final _tokensOption = null;
  final _countdown = 2;
  return _create(_self, _tokensOption, _countdown, account, password, salt, name, remark, role);
}
// end create

// begin update-role
Future<Tuple<Tuple<String, String>, bool>> _updateRole(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt _fsmid, BigInt role) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'role': role.toString()});
  final _signbody = 'role=$role';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/operator/${_fsmid}/update-role|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/operator/${_fsmid}/update-role', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    if (_code == 200) {
      return Tuple<Tuple<String, String>, bool>(_tokensOption, _respbody['payload'] == 'Okay');
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _updateRole(_self, _tokensOption, _countdown, _fsmid, role);
      } on ApiException {
        sleep(const Duration(seconds:1));
        _countdown -= 1;
        return _updateRole(_self, _tokensOption, _countdown, _fsmid, role);
      }
    } else {
      throw ApiException(_code, _respbody['payload']);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, bool>> updateRole(Caller _self, BigInt _fsmid, BigInt role) async {
  final _tokensOption = null;
  final _countdown = 2;
  return _updateRole(_self, _tokensOption, _countdown, _fsmid, role);
}
// end update-role

// begin update-password
Future<Tuple<Tuple<String, String>, bool>> _updatePassword(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt _fsmid, String password, BigInt salt) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'password': password, 'salt': salt.toString()});
  final _signbody = 'password=$password&salt=$salt';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/operator/${_fsmid}/update-password|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/operator/${_fsmid}/update-password', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    if (_code == 200) {
      return Tuple<Tuple<String, String>, bool>(_tokensOption, _respbody['payload'] == 'Okay');
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _updatePassword(_self, _tokensOption, _countdown, _fsmid, password, salt);
      } on ApiException {
        sleep(const Duration(seconds:1));
        _countdown -= 1;
        return _updatePassword(_self, _tokensOption, _countdown, _fsmid, password, salt);
      }
    } else {
      throw ApiException(_code, _respbody['payload']);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, bool>> updatePassword(Caller _self, BigInt _fsmid, String password, BigInt salt) async {
  final _tokensOption = null;
  final _countdown = 2;
  return _updatePassword(_self, _tokensOption, _countdown, _fsmid, password, salt);
}
// end update-password

// begin update
Future<Tuple<Tuple<String, String>, bool>> _update(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt _fsmid, String name, String remark) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'name': name, 'remark': remark});
  final _signbody = 'name=$name&remark=$remark';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/operator/${_fsmid}/update|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/operator/${_fsmid}/update', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    if (_code == 200) {
      return Tuple<Tuple<String, String>, bool>(_tokensOption, _respbody['payload'] == 'Okay');
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _update(_self, _tokensOption, _countdown, _fsmid, name, remark);
      } on ApiException {
        sleep(const Duration(seconds:1));
        _countdown -= 1;
        return _update(_self, _tokensOption, _countdown, _fsmid, name, remark);
      }
    } else {
      throw ApiException(_code, _respbody['payload']);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, bool>> update(Caller _self, BigInt _fsmid, String name, String remark) async {
  final _tokensOption = null;
  final _countdown = 2;
  return _update(_self, _tokensOption, _countdown, _fsmid, name, remark);
}
// end update

// begin disable
Future<Tuple<Tuple<String, String>, bool>> _disable(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt _fsmid) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({});
  final _signbody = '';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/operator/${_fsmid}/disable|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/operator/${_fsmid}/disable', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    if (_code == 200) {
      return Tuple<Tuple<String, String>, bool>(_tokensOption, _respbody['payload'] == 'Okay');
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _disable(_self, _tokensOption, _countdown, _fsmid);
      } on ApiException {
        sleep(const Duration(seconds:1));
        _countdown -= 1;
        return _disable(_self, _tokensOption, _countdown, _fsmid);
      }
    } else {
      throw ApiException(_code, _respbody['payload']);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, bool>> disable(Caller _self, BigInt _fsmid) async {
  final _tokensOption = null;
  final _countdown = 2;
  return _disable(_self, _tokensOption, _countdown, _fsmid);
}
// end disable

// begin enable
Future<Tuple<Tuple<String, String>, bool>> _enable(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt _fsmid) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({});
  final _signbody = '';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/operator/${_fsmid}/enable|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/operator/${_fsmid}/enable', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    if (_code == 200) {
      return Tuple<Tuple<String, String>, bool>(_tokensOption, _respbody['payload'] == 'Okay');
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _enable(_self, _tokensOption, _countdown, _fsmid);
      } on ApiException {
        sleep(const Duration(seconds:1));
        _countdown -= 1;
        return _enable(_self, _tokensOption, _countdown, _fsmid);
      }
    } else {
      throw ApiException(_code, _respbody['payload']);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, bool>> enable(Caller _self, BigInt _fsmid) async {
  final _tokensOption = null;
  final _countdown = 2;
  return _enable(_self, _tokensOption, _countdown, _fsmid);
}
// end enable
