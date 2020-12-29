import 'dart:math';

import 'dart:typed_data';

import 'dart:convert';

import 'package:crypto/crypto.dart';

class Pagination<T> {
  final List<T> data;
  final int offset;
  final int limit;
  const Pagination(this.data, this.offset, this.limit);
}

class Caller {
  final String schema;
  final String host;
  final int port;
  final String basePath;
  final String appid;
  final String appkey;
  final Random rand;
  String accessToken;
  String refreshToken;
  Caller(this.schema, this.host, this.port, this.basePath, this.appid, this.appkey, this.rand);
}

class ApiException implements Exception {
  final int code;
  final String error;
  const ApiException(this.code, this.error);
}

class Tuple<A, B> {
  A a; B b;
  Tuple(this.a, this.b);
   @override bool operator ==(other) => other is Tuple<A, B> && other.a == a && other.b == b;
}

Digest md5XorUint32s(List<int> md5Bytes, int a0, int a1, int a2, int a3) {
  var buffer = Uint8List(16).buffer;
  var bdata = ByteData.view(buffer);
  bdata.setUint32(0, a0);
  bdata.setUint32(4, a1);
  bdata.setUint32(8, a2);
  bdata.setUint32(12, a3);
  final bytes = Uint8List.view(buffer);
  var result = Uint8List(md5Bytes.length);
  for (var i = 0; i < md5Bytes.length; i ++) {
    result[i] = md5Bytes[i] ^ bytes[i];
  }
  return Digest(result.toList());
}

String addSalt(String password, BigInt salt) {
  final l = (salt & BigInt.from(0xFFFFFFFF)).toInt();
  final h = ((salt >> 32) & BigInt.from(0xFFFFFFFF)).toInt();
  final pwmd5 = md5.convert(utf8.encode(password));
  final passwd = md5XorUint32s(pwmd5.bytes, h, l, h, l);
  return passwd.toString();
}
