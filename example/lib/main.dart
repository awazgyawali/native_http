import 'package:flutter/material.dart';
import 'dart:async';

import 'package:native_http/native_http.dart' as native_http;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    runCalls();
  }

  Future<void> runCalls() async {
    native_http.NativeResponse respGet =
        await native_http.get("https://baidu.com/get");
    print(respGet.body);
    native_http.NativeResponse respPost = await native_http.post(
      "http://example.com/get",
      body: {"username": "username", "password": "password"},
    );
    print(respPost.body);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Ran an http call'),
        ),
      ),
    );
  }
}
