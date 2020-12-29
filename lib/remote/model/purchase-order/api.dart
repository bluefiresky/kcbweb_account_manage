import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api-helper.dart';
import '../session/api.dart' as session;
import 'model.dart';
import '../purchaser/model.dart';
import '../stock-keeping-unit/model.dart';
import '../purchaser/api.dart';
import '../stock-keeping-unit/api.dart';

PurchaseOrderItem getPurchaseOrderItemFromJson(Map<String, dynamic> node) {
  final sku = BigInt.parse(node['sku']['fsmid']);
  final skuRef = getStockKeepingUnitFromJson(node['sku']);
  final code = node['code'];
  final name = node['name'];
  final features = node['features'].map<String, String>((k0, v0) => MapEntry<String, String>(k0, v0));
  final quantity = node['quantity'];
  final price = node['price'];
  final purchaseOrderItem = PurchaseOrderItem(sku, skuRef, code, name, features, quantity, price);
  return purchaseOrderItem;
}

PurchaseOrder getPurchaseOrderFromJson(Map<String, dynamic> node) {
  final fsmid = BigInt.parse(node['fsmid']);
  final no = node['no'];
  final purchaser = BigInt.parse(node['purchaser']['fsmid']);
  final purchaserRef = getPurchaserFromJson(node['purchaser']);
  final items = List<PurchaseOrderItem>.from(node['items'].map((i0) => getPurchaseOrderItemFromJson(i0)));
  final deliveryAddress = node['delivery-address'];
  final payment = BigInt.parse(node['payment']);
  final paymentSerialNumber = node['payment-serial-number'];
  final deliveryCompany = node['delivery-company'];
  final deliverySerialNumber = node['delivery-serial-number'];
  final reason = node['reason'];
  final purchaseOrder = PurchaseOrder(fsmid, no, purchaser, purchaserRef, items, deliveryAddress, payment, paymentSerialNumber, deliveryCompany, deliverySerialNumber, reason);
  return purchaseOrder;
}

Future<Tuple<Tuple<String, String>, PurchaseOrder>> _getPurchaseOrder(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt _fsmid) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = '';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/purchase-order/${_fsmid}|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/${_fsmid}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    if (_code == 200) {
      return Tuple<Tuple<String, String>, PurchaseOrder>(_tokensOption, getPurchaseOrderFromJson(_respbody['payload']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getPurchaseOrder(_self, _tokensOption, _countdown, _fsmid);
      } on ApiException {
        sleep(const Duration(seconds:1));
        _countdown -= 1;
        return _getPurchaseOrder(_self, _tokensOption, _countdown, _fsmid);
      }
    } else {
      throw ApiException(_code, _respbody['payload']);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, PurchaseOrder>> getPurchaseOrder(Caller _self, BigInt _fsmid) async {
  final _tokensOption = null;
  final _countdown = 2;
  return _getPurchaseOrder(_self, _tokensOption, _countdown, _fsmid);
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _getAllPurchaseOrderList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/purchase-order/all|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/all?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getAllPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getAllPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> getAllPurchaseOrderList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getAllPurchaseOrderList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _getPendingPaymentPurchaseOrderList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/purchase-order/pending-payment|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/pending-payment?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getPendingPaymentPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getPendingPaymentPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> getPendingPaymentPurchaseOrderList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getPendingPaymentPurchaseOrderList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _getPendingPurchaseOrderList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/purchase-order/pending|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/pending?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getPendingPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getPendingPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> getPendingPurchaseOrderList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getPendingPurchaseOrderList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _getLockedPurchaseOrderList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/purchase-order/locked|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/locked?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getLockedPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getLockedPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> getLockedPurchaseOrderList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getLockedPurchaseOrderList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _getDistributingPurchaseOrderList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/purchase-order/distributing|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/distributing?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDistributingPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getDistributingPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> getDistributingPurchaseOrderList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getDistributingPurchaseOrderList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _getDeliveredPurchaseOrderList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/purchase-order/delivered|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/delivered?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDeliveredPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getDeliveredPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> getDeliveredPurchaseOrderList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getDeliveredPurchaseOrderList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _getDonePurchaseOrderList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/purchase-order/done|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/done?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDonePurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getDonePurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> getDonePurchaseOrderList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getDonePurchaseOrderList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _getPendingRefundPurchaseOrderList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/purchase-order/pending-refund|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/pending-refund?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getPendingRefundPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getPendingRefundPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> getPendingRefundPurchaseOrderList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getPendingRefundPurchaseOrderList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _getClosedPurchaseOrderList(Caller _self, Tuple<String, String> _tokensOption, int _countdown, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = 'limit=${limit}&offset=${offset}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/purchase-order/closed|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/closed?limit=${limit}&offset=${offset}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getClosedPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _getClosedPurchaseOrderList(_self, _tokensOption, _countdown - 1, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> getClosedPurchaseOrderList(Caller _self, {int offset = 0, int limit = 10}) async {
  return _getClosedPurchaseOrderList(_self, Tuple<String, String>(null, null), 2, offset: offset, limit: limit);
}

// begin search-purchase-order-in-all
Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _searchPurchaseOrderInAll(Caller _self, Tuple<String, String> _tokensOption, int _countdown, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'words': words, 'limit': limit, 'offset': offset});
  final _signbody = 'limit=${limit}&offset=${offset}&words=${json.encode(words)}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/purchase-order/search/all|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/search/all', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        return _searchPurchaseOrderInAll(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _searchPurchaseOrderInAll(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> searchPurchaseOrderInAll(Caller _self, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  return _searchPurchaseOrderInAll(_self, Tuple<String, String>(null, null), 2, words, offset: offset, limit: limit);
}
// end search-purchase-order-in-all

// begin search-purchase-order-in-pending-payment
Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _searchPurchaseOrderInPendingPayment(Caller _self, Tuple<String, String> _tokensOption, int _countdown, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'words': words, 'limit': limit, 'offset': offset});
  final _signbody = 'limit=${limit}&offset=${offset}&words=${json.encode(words)}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/purchase-order/search/pending-payment|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/search/pending-payment', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        return _searchPurchaseOrderInPendingPayment(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _searchPurchaseOrderInPendingPayment(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> searchPurchaseOrderInPendingPayment(Caller _self, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  return _searchPurchaseOrderInPendingPayment(_self, Tuple<String, String>(null, null), 2, words, offset: offset, limit: limit);
}
// end search-purchase-order-in-pending-payment

// begin search-purchase-order-in-pending
Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _searchPurchaseOrderInPending(Caller _self, Tuple<String, String> _tokensOption, int _countdown, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'words': words, 'limit': limit, 'offset': offset});
  final _signbody = 'limit=${limit}&offset=${offset}&words=${json.encode(words)}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/purchase-order/search/pending|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/search/pending', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        return _searchPurchaseOrderInPending(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _searchPurchaseOrderInPending(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> searchPurchaseOrderInPending(Caller _self, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  return _searchPurchaseOrderInPending(_self, Tuple<String, String>(null, null), 2, words, offset: offset, limit: limit);
}
// end search-purchase-order-in-pending

// begin search-purchase-order-in-locked
Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _searchPurchaseOrderInLocked(Caller _self, Tuple<String, String> _tokensOption, int _countdown, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'words': words, 'limit': limit, 'offset': offset});
  final _signbody = 'limit=${limit}&offset=${offset}&words=${json.encode(words)}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/purchase-order/search/locked|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/search/locked', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        return _searchPurchaseOrderInLocked(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _searchPurchaseOrderInLocked(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> searchPurchaseOrderInLocked(Caller _self, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  return _searchPurchaseOrderInLocked(_self, Tuple<String, String>(null, null), 2, words, offset: offset, limit: limit);
}
// end search-purchase-order-in-locked

// begin search-purchase-order-in-distributing
Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _searchPurchaseOrderInDistributing(Caller _self, Tuple<String, String> _tokensOption, int _countdown, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'words': words, 'limit': limit, 'offset': offset});
  final _signbody = 'limit=${limit}&offset=${offset}&words=${json.encode(words)}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/purchase-order/search/distributing|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/search/distributing', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        return _searchPurchaseOrderInDistributing(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _searchPurchaseOrderInDistributing(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> searchPurchaseOrderInDistributing(Caller _self, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  return _searchPurchaseOrderInDistributing(_self, Tuple<String, String>(null, null), 2, words, offset: offset, limit: limit);
}
// end search-purchase-order-in-distributing

// begin search-purchase-order-in-delivered
Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _searchPurchaseOrderInDelivered(Caller _self, Tuple<String, String> _tokensOption, int _countdown, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'words': words, 'limit': limit, 'offset': offset});
  final _signbody = 'limit=${limit}&offset=${offset}&words=${json.encode(words)}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/purchase-order/search/delivered|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/search/delivered', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        return _searchPurchaseOrderInDelivered(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _searchPurchaseOrderInDelivered(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> searchPurchaseOrderInDelivered(Caller _self, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  return _searchPurchaseOrderInDelivered(_self, Tuple<String, String>(null, null), 2, words, offset: offset, limit: limit);
}
// end search-purchase-order-in-delivered

// begin search-purchase-order-in-done
Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _searchPurchaseOrderInDone(Caller _self, Tuple<String, String> _tokensOption, int _countdown, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'words': words, 'limit': limit, 'offset': offset});
  final _signbody = 'limit=${limit}&offset=${offset}&words=${json.encode(words)}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/purchase-order/search/done|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/search/done', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        return _searchPurchaseOrderInDone(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _searchPurchaseOrderInDone(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> searchPurchaseOrderInDone(Caller _self, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  return _searchPurchaseOrderInDone(_self, Tuple<String, String>(null, null), 2, words, offset: offset, limit: limit);
}
// end search-purchase-order-in-done

// begin search-purchase-order-in-pending-refund
Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _searchPurchaseOrderInPendingRefund(Caller _self, Tuple<String, String> _tokensOption, int _countdown, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'words': words, 'limit': limit, 'offset': offset});
  final _signbody = 'limit=${limit}&offset=${offset}&words=${json.encode(words)}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/purchase-order/search/pending-refund|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/search/pending-refund', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        return _searchPurchaseOrderInPendingRefund(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _searchPurchaseOrderInPendingRefund(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> searchPurchaseOrderInPendingRefund(Caller _self, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  return _searchPurchaseOrderInPendingRefund(_self, Tuple<String, String>(null, null), 2, words, offset: offset, limit: limit);
}
// end search-purchase-order-in-pending-refund

// begin search-purchase-order-in-closed
Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> _searchPurchaseOrderInClosed(Caller _self, Tuple<String, String> _tokensOption, int _countdown, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _body = json.encode({'words': words, 'limit': limit, 'offset': offset});
  final _signbody = 'limit=${limit}&offset=${offset}&words=${json.encode(words)}';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('POST|/purchase-order/search/closed|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.post('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/purchase-order/search/closed', headers: _headers, body: _body);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    final _payload = _respbody['payload'];
    if (_code == 200) {
      var _data = [];
      for (final _e in _payload['data']) {
        final purchaseOrder = getPurchaseOrderFromJson(_e);
        _data.add(purchaseOrder);
      }
      final _pagination = _payload['pagination'];
      return Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>(_tokensOption, Pagination<PurchaseOrder>(_data.cast<PurchaseOrder>(), _pagination['offset'], _pagination['limit']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        return _searchPurchaseOrderInClosed(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      } on ApiException {
        sleep(const Duration(seconds:1));
        return _searchPurchaseOrderInClosed(_self, _tokensOption, _countdown - 1, words, offset: offset, limit: limit);
      }
    } else {
      throw ApiException(_code, _payload);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, Pagination<PurchaseOrder>>> searchPurchaseOrderInClosed(Caller _self, Map<String, String> words, {int offset = 0, int limit = 10}) async {
  return _searchPurchaseOrderInClosed(_self, Tuple<String, String>(null, null), 2, words, offset: offset, limit: limit);
}
// end search-purchase-order-in-closed
