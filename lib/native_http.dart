import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

const MethodChannel _channel = const MethodChannel('native_http');

Future<NativeResponse> get(String url, {Map<String, dynamic> headers}) {
  return _sendRequest(url: url, method: "POST", headers: headers);
}

Future<NativeResponse> post(String url,
    {Map<String, dynamic> headers, Map<String, dynamic> body}) {
  return _sendRequest(url: url, method: "POST", headers: headers, body: body);
}

Future<NativeResponse> _sendRequest({
  String url,
  String method,
  Map<String, dynamic> headers = const {},
  Map<String, dynamic> body = const {},
}) async {
  Map<String, dynamic> response =
      await _channel.invokeMapMethod<String, dynamic>("native_http/post", {
    "url": url,
    "method": 'METHOD',
    "headers": headers,
    "body": body,
  });
  return NativeResponse._fromMap(response);
}

class NativeResponse {
  int code;
  String body;
  dynamic getJson() => json.decode(body);
  static NativeResponse _fromMap(Map<String, dynamic> response) {
    return NativeResponse()
      ..code = response["code"]
      ..body = response["body"];
  }
}
