# native_http

A package that calls network from native platform ie OkHttp on Android and URLSession iOS.

## Getting Started

```
  import 'package:native_http/native_http.dart' as native_http;


  Future<void> runCalls() async {
    native_http.NativeResponse respGet =
        await native_http.get("http://example.com/get");
    print(respGet.body);
    native_http.NativeResponse respPost = await native_http.post(
      "http://example.com/get",
      body: {"username": "username", "password": "password"},
    );
    print(respPost.body);
  }

```
