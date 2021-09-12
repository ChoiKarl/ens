import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';

class Network {
  Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://openapi.youdao.com',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded;charset=utf-8',
      },
    ),
  );

  static Network? _instance;

  static Network get shared {
    _instance ??= Network();
    return _instance!;
  }

  Future<Response> post(String path, Map<String, Object> params) async {
    Response response = await _dio.post(path, data: params);
    return response;
  }
}

extension Query on Network {
  Future<Response> queryWord(String word) async {
    String appKey = '5adb2fd1b6c7d7b0';
    String appSecret = 'FB8iCCExGGppp2YQ9uzqIlq8lMjgbZxc';
    var ql = utf8.encode(word);
    String q = utf8.decode(ql);
    String salt = (await DeviceInfoPlugin().iosInfo).identifierForVendor;
    String curtime = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    String input = word;
    String signSource = appKey + input + salt + curtime + appSecret;
    var content = utf8.encode(signSource);
    String sign = sha256.convert(content).toString();
    return post('/api', {
      'q': q,
      'from': 'en',
      'to': 'zh-CHS',
      'appKey': appKey,
      'salt': salt,
      'sign': sign,
      'signType': 'v3',
      'curtime': curtime,
    });
  }
}
