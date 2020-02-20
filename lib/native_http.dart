import 'dart:async';

import 'package:flutter/services.dart';

class NativeHttp {
  static const MethodChannel _channel =
      const MethodChannel('native_http');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
