import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:native_http/native_http.dart';

void main() {
  const MethodChannel channel = MethodChannel('native_http');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await NativeHttp.platformVersion, '42');
  });
}
