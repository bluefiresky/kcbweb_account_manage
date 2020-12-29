import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../api-helper.dart';

Future<Tuple<String, String>> login(Caller self, String account, String password, int pin) async {
  final noise1 = self.rand.nextInt(0xFFFFFFFF);
  final noise2 = self.rand.nextInt(0xFFFFFFFF);
  final pwmd5 = md5.convert(utf8.encode(password));
  final passwd = md5XorUint32s(pwmd5.bytes, noise1, noise2, noise1, noise2);
  final body = json.encode({'account': account, 'password': passwd.toString(), 'pin': pin});
  final signbody = 'account=${account}&password=${passwd.toString()}&pin=${pin}';
  final now = DateTime.now().toUtc();
  final formatter = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US');
  final date = formatter.format(now) + ' GMT';
  final hmacSha256 = Hmac(sha256, utf8.encode(self.appkey));
  final secretValue = hmacSha256.convert(utf8.encode('POST|/session/login|${signbody}|${date}'));
  final headers = {
    'x-date': date,
    'Authorization': '${self.appid}:${secretValue}',
    'x-noise': '${noise1.toRadixString(16)}${noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': self.accessToken,
  };
  final response = await http.post('${self.schema}://${self.host}:${self.port}${self.basePath}/session/login', headers: headers, body: body);
  if (response.statusCode == 200) {
    final respbody = jsonDecode(response.body);
    final int code = respbody['code'];
    if (code == 200) {
      final accessToken = respbody['payload']['access-token'];
      final refreshToken = respbody['payload']['refresh-token'];
      return Tuple<String, String>(accessToken, refreshToken);
    } else {
      throw ApiException(code, respbody['payload']);
    }
  } else {
    throw ApiException(response.statusCode, response.body);
  }
}

Future<Tuple<String, String>> refresh(Caller self) async {
  final noise1 = self.rand.nextInt(0xFFFFFFFF);
  final noise2 = self.rand.nextInt(0xFFFFFFFF);
  final body = json.encode({'old-token': self.refreshToken});
  final signbody = 'old-token=${self.refreshToken}';
  final now = DateTime.now().toUtc();
  final formatter = DateFormat('EEE, dd MMM yyyy HH:mm:ss', 'en_US');
  final date = formatter.format(now) + ' GMT';
  final hmacSha256 = Hmac(sha256, utf8.encode(self.appkey));
  final secretValue = hmacSha256.convert(utf8.encode('POST|/session/refresh|${signbody}|${date}'));
  final headers = {
    'x-date': date,
    'Authorization': '${self.appid}:${secretValue}',
    'x-noise': '${noise1.toRadixString(16)}${noise2.toRadixString(16).padLeft(8, '0')}',
    'x-token': self.accessToken,
  };
  final response = await http.post('${self.schema}://${self.host}:${self.port}${self.basePath}/session/refresh', headers: headers, body: body);
  if (response.statusCode == 200) {
    final respbody = jsonDecode(response.body);
    final int code = respbody['code'];
    if (code == 200) {
      final accessToken = respbody['payload']['access-token'];
      final refreshToken = respbody['payload']['refresh-token'];
      return Tuple<String, String>(accessToken, refreshToken);
    } else {
      throw ApiException(code, respbody['payload']);
    }
  } else {
    throw ApiException(response.statusCode, response.body);
  }
}
