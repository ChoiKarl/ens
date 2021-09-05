import 'dart:convert';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:ens/network/network_result.dart';
import 'package:crypto/crypto.dart';

class Network {
  Dio _dio = Dio(BaseOptions(baseUrl: 'https://openapi.youdao.com'));

  static Network? _instance;

  static Network get shared {
    _instance ??= Network();
    return _instance!;
  }

  Future<NetworkResult> post(String path, Map<String, Object> params) async {
    Response response = await _dio.post(path, data: params);
    print(response.data);
    return Future.value(NetworkResult());
  }
}

extension Query on Network {
  Future<NetworkResult> queryWord(String word) async {
    String appID = '5adb2fd1b6c7d7b0';
    String appKey = 'FB8iCCExGGppp2YQ9uzqIlq8lMjgbZxc';
    String salt = (await DeviceInfoPlugin().iosInfo).identifierForVendor;
    int curTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    String input = word.length > 20
        ? word.substring(0, 10) + '${word.length}' + word.substring(word.length - 10, word.length)
        : word;

    String signSource = appID + input + salt + '$curTime' + appKey;
    var bytes = utf8.encode(signSource);
    var sign = sha256.convert(bytes).toString();
    print('sign = $sign');
/*
* sign=sha256(应用ID+input+salt+curtime+应用密钥)；
  其中，input的计算方式为：input=q前10个字符 + q长度 + q后10个字符（当q长度大于20）或 input=q字符串（当q长度小于等于20）；
* */
    return post('/api', {
      'q': word,
      'from': 'en',
      'to': 'zh-CHS',
      'appKey': appID,
      'salt': salt,
      'sign': sign,
      'signType': 'v3',
      'curtime': curTime,
    });
  }
}
