import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api-helper.dart';
import '../session/api.dart' as session;
import 'model.dart';
import '../purchase-order/model.dart';
import '../supplier/model.dart';
import '../stock-keeping-unit/model.dart';
import '../purchase-order/api.dart';
import '../supplier/api.dart';
import '../stock-keeping-unit/api.dart';

SupplyOrderItem getSupplyOrderItemFromJson(Map<String, dynamic> node) {
  final sku = BigInt.parse(node['sku']['fsmid']);
  final skuRef = getStockKeepingUnitFromJson(node['sku']);
  final code = node['code'];
  final name = node['name'];
  final features = node['features'].map<String, String>((k0, v0) => MapEntry<String, String>(k0, v0));
  final quantity = node['quantity'];
  final price = node['price'];
  final supplyOrderItem = SupplyOrderItem(sku, skuRef, code, name, features, quantity, price);
  return supplyOrderItem;
}

SupplyOrder getSupplyOrderFromJson(Map<String, dynamic> node) {
  final fsmid = BigInt.parse(node['fsmid']);
  final no = node['no'];
  final supplier = BigInt.parse(node['supplier']['fsmid']);
  final supplierRef = getSupplierFromJson(node['supplier']);
  final deliveryAddress = node['delivery-address'];
  final items = List<SupplyOrderItem>.from(node['items'].map((i0) => getSupplyOrderItemFromJson(i0)));
  final purchaseOrders = List<BigInt>.from(node['purchase-orders'].map((i) => BigInt.parse(i['fsmid'])));
  final purchaseOrdersRefs = List<PurchaseOrder>.from(node['purchase-orders'].map((i) => getPurchaseOrderFromJson(i)));
  final deliveryCompany = node['delivery-company'];
  final deliverySerialNumber = node['delivery-serial-number'];
  final reason = node['reason'];
  final supplyOrder = SupplyOrder(fsmid, no, supplier, supplierRef, deliveryAddress, items, purchaseOrders, purchaseOrdersRefs, deliveryCompany, deliverySerialNumber, reason);
  return supplyOrder;
}

Future<Tuple<Tuple<String, String>, SupplyOrder>> _getSupplyOrder(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt _fsmid) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = '';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/supply-order/${_fsmid}|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/supply-order/${_fsmid}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    if (_code == 200) {
      return Tuple<Tuple<String, String>, SupplyOrder>(_tokensOption, getSupplyOrderFromJson(_respbody['payload']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getSupplyOrder(_self, _tokensOption, _countdown, _fsmid);
      } on ApiException {
        sleep(const Duration(seconds:1));
        _countdown -= 1;
        return _getSupplyOrder(_self, _tokensOption, _countdown, _fsmid);
      }
    } else {
      throw ApiException(_code, _respbody['payload']);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, SupplyOrder>> getSupplyOrder(Caller _self, BigInt _fsmid) async {
  final _tokensOption = null;
  final _countdown = 2;
  return _getSupplyOrder(_self, _tokensOption, _countdown, _fsmid);
}

Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> _getAllSupplyOrderList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/supply-order/all|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/supply-order/all?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final supplyOrder = getSupplyOrderFromJson(_e);
        _data.add(supplyOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<SupplyOrder>>(_tokensOption, Pagination<SupplyOrder>(_data.cast<SupplyOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getAllSupplyOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getAllSupplyOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> getAllSupplyOrderList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getAllSupplyOrderList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> _getPendingSupplyOrderList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/supply-order/pending|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/supply-order/pending?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final supplyOrder = getSupplyOrderFromJson(_e);
        _data.add(supplyOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<SupplyOrder>>(_tokensOption, Pagination<SupplyOrder>(_data.cast<SupplyOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getPendingSupplyOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getPendingSupplyOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> getPendingSupplyOrderList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getPendingSupplyOrderList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> _getDeliveredSupplyOrderList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/supply-order/delivered|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/supply-order/delivered?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final supplyOrder = getSupplyOrderFromJson(_e);
        _data.add(supplyOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<SupplyOrder>>(_tokensOption, Pagination<SupplyOrder>(_data.cast<SupplyOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDeliveredSupplyOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getDeliveredSupplyOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> getDeliveredSupplyOrderList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getDeliveredSupplyOrderList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> _getDoneSupplyOrderList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/supply-order/done|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/supply-order/done?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final supplyOrder = getSupplyOrderFromJson(_e);
        _data.add(supplyOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<SupplyOrder>>(_tokensOption, Pagination<SupplyOrder>(_data.cast<SupplyOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDoneSupplyOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getDoneSupplyOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> getDoneSupplyOrderList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getDoneSupplyOrderList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> _getClosedSupplyOrderList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/supply-order/closed|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/supply-order/closed?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final supplyOrder = getSupplyOrderFromJson(_e);
        _data.add(supplyOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<SupplyOrder>>(_tokensOption, Pagination<SupplyOrder>(_data.cast<SupplyOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getClosedSupplyOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getClosedSupplyOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> getClosedSupplyOrderList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getClosedSupplyOrderList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

// begin search-supply-order-in-all
Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> _searchSupplyOrderInAll(Caller _self, Tuple<String, String> _tokensOption, int _countdown, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'words': words, 'limit': limit, 'offset': offset});
  final _signbody = 'limit=${limit}&offset=${offset}&words=${json.encode(words)}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/supply-order/search/all|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/supply-order/search/all', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final supplyOrder = getSupplyOrderFromJson(_e);
        _data.add(supplyOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<SupplyOrder>>(_tokensOption, Pagination<SupplyOrder>(_data.cast<SupplyOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        return _searchSupplyOrderInAll(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _searchSupplyOrderInAll(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> searchSupplyOrderInAll(Caller _self, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  return _searchSupplyOrderInAll(_self, Tuple<String, String>(null, null), 2, words, offset: offset, limit: limit);
}
// end search-supply-order-in-all

// begin search-supply-order-in-pending
Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> _searchSupplyOrderInPending(Caller _self, Tuple<String, String> _tokensOption, int _countdown, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'words': words, 'limit': limit, 'offset': offset});
  final _signbody = 'limit=${limit}&offset=${offset}&words=${json.encode(words)}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/supply-order/search/pending|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/supply-order/search/pending', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final supplyOrder = getSupplyOrderFromJson(_e);
        _data.add(supplyOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<SupplyOrder>>(_tokensOption, Pagination<SupplyOrder>(_data.cast<SupplyOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        return _searchSupplyOrderInPending(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _searchSupplyOrderInPending(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> searchSupplyOrderInPending(Caller _self, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  return _searchSupplyOrderInPending(_self, Tuple<String, String>(null, null), 2, words, offset: offset, limit: limit);
}
// end search-supply-order-in-pending

// begin search-supply-order-in-delivered
Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> _searchSupplyOrderInDelivered(Caller _self, Tuple<String, String> _tokensOption, int _countdown, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'words': words, 'limit': limit, 'offset': offset});
  final _signbody = 'limit=${limit}&offset=${offset}&words=${json.encode(words)}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/supply-order/search/delivered|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/supply-order/search/delivered', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final supplyOrder = getSupplyOrderFromJson(_e);
        _data.add(supplyOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<SupplyOrder>>(_tokensOption, Pagination<SupplyOrder>(_data.cast<SupplyOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        return _searchSupplyOrderInDelivered(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _searchSupplyOrderInDelivered(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> searchSupplyOrderInDelivered(Caller _self, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  return _searchSupplyOrderInDelivered(_self, Tuple<String, String>(null, null), 2, words, offset: offset, limit: limit);
}
// end search-supply-order-in-delivered

// begin search-supply-order-in-done
Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> _searchSupplyOrderInDone(Caller _self, Tuple<String, String> _tokensOption, int _countdown, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'words': words, 'limit': limit, 'offset': offset});
  final _signbody = 'limit=${limit}&offset=${offset}&words=${json.encode(words)}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/supply-order/search/done|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/supply-order/search/done', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final supplyOrder = getSupplyOrderFromJson(_e);
        _data.add(supplyOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<SupplyOrder>>(_tokensOption, Pagination<SupplyOrder>(_data.cast<SupplyOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        return _searchSupplyOrderInDone(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _searchSupplyOrderInDone(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> searchSupplyOrderInDone(Caller _self, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  return _searchSupplyOrderInDone(_self, Tuple<String, String>(null, null), 2, words, offset: offset, limit: limit);
}
// end search-supply-order-in-done

// begin search-supply-order-in-closed
Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> _searchSupplyOrderInClosed(Caller _self, Tuple<String, String> _tokensOption, int _countdown, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'words': words, 'limit': limit, 'offset': offset});
  final _signbody = 'limit=${limit}&offset=${offset}&words=${json.encode(words)}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/supply-order/search/closed|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/supply-order/search/closed', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final supplyOrder = getSupplyOrderFromJson(_e);
        _data.add(supplyOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<SupplyOrder>>(_tokensOption, Pagination<SupplyOrder>(_data.cast<SupplyOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        return _searchSupplyOrderInClosed(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _searchSupplyOrderInClosed(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<SupplyOrder>>> searchSupplyOrderInClosed(Caller _self, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  return _searchSupplyOrderInClosed(_self, Tuple<String, String>(null, null), 2, words, offset: offset, limit: limit);
}
// end search-supply-order-in-closed
