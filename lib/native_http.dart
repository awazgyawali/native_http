import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

const MethodChannel _channel = const MethodChannel('native_http');

Future<NativeResponse> get(String url, {
  Map<String, dynamic> headers = const {},
}) {
  return request(url: url, method: "GET", headers: headers);
}

Future<NativeResponse> post(String url, {
  Map<String, dynamic> headers = const {},
  Map<String, dynamic> body = const {},
}) {
  return request(url: url, method: "POST", headers: headers, body: body);
}

Future<NativeResponse> request({required String url,
  required String method,
  Map<String, dynamic>? headers,
  Map<String, dynamic>? body}) async {
  Map<String, dynamic>? response =
  await _channel.invokeMapMethod<String, dynamic>("native_http/request", {
    "url": url,
    "method": method,
    "headers": headers,
    "body": body,
  });
  return NativeResponse._fromMap(response);
}

class NativeResponse {
  int? code;
  String? body;

  dynamic getJson() => json.decode(body ?? "");

  static NativeResponse _fromMap(Map<String, dynamic>? response) {
    return NativeResponse()
      ..code = response?["code"] ?? 0
      ..body = response?["body"];
  }
}
