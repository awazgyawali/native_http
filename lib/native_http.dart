import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const MethodChannel _channel = const MethodChannel('native_http');

Future<NativeResponse> get(
  String url, {
  Map<String, String> headers = const {},
}) async {
  return request(url: url, method: "GET", headers: headers);
}

Future<NativeResponse> post(
  String url, {
  Map<String, String> headers = const {},
  Map<String, dynamic> body = const {},
}) async {
  return request(url: url, method: "POST", headers: headers, body: body);
}

Future<NativeResponse> request(
    {String url,
    String method,
    Map<String, dynamic> headers,
    Map<String, dynamic> body}) async {
  if (kIsWeb) {
    var response;
    switch (method) {
      case "GET":
        response = await http.get(
          url,
          headers: headers,
        );
        break;
      case "POST":
        response = await http.post(
          url,
          headers: headers,
          body: body,
        );
        break;
      case "PUT":
        response = await http.put(
          url,
          headers: headers,
          body: body,
        );
        break;
      case "DELETE":
        response = await http.delete(
          url,
          headers: headers,
        );
        break;
      case "PATCH":
        response = await http.patch(
          url,
          headers: headers,
          body: body,
        );
        break;
      case "HEAD":
        response = await http.head(
          url,
          headers: headers,
        );
        break;
      default:
        throw Exception(
            "Invalid request method. Only supports GET, POST, PUT, PATCH, DELETE, HEAD");
    }

    return NativeResponse._fromMap({
      "code": response.statusCode,
      "body": response.body,
    });
  }
  Map<String, dynamic> response =
      await _channel.invokeMapMethod<String, dynamic>("native_http/request", {
    "url": url,
    "method": method,
    "headers": headers,
    "body": body,
  });
  return NativeResponse._fromMap(response);
}

class NativeResponse {
  int code;
  String body;
  dynamic get json => json.decode(body);
  static NativeResponse _fromMap(Map<String, dynamic> response) {
    return NativeResponse()
      ..code = response["code"]
      ..body = response["body"];
  }
}
