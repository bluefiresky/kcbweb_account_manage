import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api-helper.dart';
import '../session/api.dart' as session;
import 'model.dart';
import '../purchaser/model.dart';
import '../purchaser/api.dart';

DeliveryAddress getDeliveryAddressFromJson(Map<String, dynamic> node) {
  final fsmid = BigInt.parse(node['fsmid']);
  final purchaser = BigInt.parse(node['purchaser']['fsmid']);
  final purchaserRef = getPurchaserFromJson(node['purchaser']);
  final address = node['address'];
  final deliveryAddress = DeliveryAddress(fsmid, purchaser, purchaserRef, address);
  return deliveryAddress;
}

Future<Tuple<Tuple<String, String>, DeliveryAddress>> _getDeliveryAddress(Caller _self, Tuple<String, String> _tokensOption, int _countdown, BigInt _fsmid) async {
  if (_countdown == 0) {
    throw ApiException(403, '会话过期');
  }
  final _signbody = '';
  final _noise1 = _self.rand.nextInt(0xFFFFFFFF);
  final _noise2 = _self.rand.nextInt(0xFFFFFFFF);
  final _date = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US').format(DateTime.now().toUtc()) + ' GMT';
  final _secretValue = Hmac(sha256, utf8.encode(_self.appkey)).convert(utf8.encode('GET|/delivery-address/${_fsmid}|${_signbody}|${_date}'));
  final _headers = {
    'x-date': _date,
    'Authorization': '${_self.appid}:${_secretValue}',
    'x-noise': '${_noise1.toRadixString(16)}${_noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': _self.accessToken,
  };
  final _response = await http.get('${_self.schema}://${_self.host}:${_self.port}${_self.basePath}/delivery-address/${_fsmid}', headers: _headers);
  if (_response.statusCode == 200) {
    final _respbody = jsonDecode(_response.body);
    final int _code = _respbody['code'];
    if (_code == 200) {
      return Tuple<Tuple<String, String>, DeliveryAddress>(_tokensOption, getDeliveryAddressFromJson(_respbody['payload']));
    } else if (_code == 403) {
      try {
        _tokensOption = await session.refresh(_self);
        _self.accessToken = _tokensOption.a;
        _self.refreshToken = _tokensOption.b;
        return _getDeliveryAddress(_self, _tokensOption, _countdown, _fsmid);
      } on ApiException {
        sleep(const Duration(seconds:1));
        _countdown -= 1;
        return _getDeliveryAddress(_self, _tokensOption, _countdown, _fsmid);
      }
    } else {
      throw ApiException(_code, _respbody['payload']);
    }
  } else {
    throw ApiException(_response.statusCode, _response.body);
  }
}

Future<Tuple<Tuple<String, String>, DeliveryAddress>> getDeliveryAddress(Caller _self, BigInt _fsmid) async {
  final _tokensOption = null;
  final _countdown = 2;
  return _getDeliveryAddress(_self, _tokensOption, _countdown, _fsmid);
}
