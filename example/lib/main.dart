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
    native_http.NativeResponse respGet = await native_http
        .get("https://5eb4371f2b81f70016308301.mockapi.io/api/users");
    native_http.NativeResponse respPost = await native_http.post(
      "http://newweb.nepalstock.com.np/api/authenticate/login",
      headers: {
        "Origin": "http://newweb.nepalstock.com.np",
        "Host": "http://newweb.nepalstock.com.np",
      },
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
          child: RaisedButton(
            child: Text('Run an http call'),
            onPressed: runCalls,
          ),
        ),
      ),
    );
  }
}
