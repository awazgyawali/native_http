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
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    native_http.NativeResponse response = await native_http.post(
      "http://newweb.nepalstock.com.np:8500/api/authenticate/login",
      body: {
        "username": "dsas",
        "password": "dsas",
      },
    );
    print(response.body);
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
