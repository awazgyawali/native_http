# native_http

A package that calls network from native platform ie OkHttp on Android and URLSession iOS.

## Getting Started

```
import 'package:native_http/native_http.dart' as native_http;

// Platform messages are asynchronous, so we initialize in an async method.
Future<void> initPlatformState() async {
    native_http.NativeResponse respGet = await native_http.get(
        "http://newweb.nepalstock.com.np:8500/api/nots/nepse-data/market-open");
    print(respGet.body);
    native_http.NativeResponse respPost = await native_http.post(
        "http://newweb.nepalstock.com.np:8500/api/authenticate/login",
        body: {
        "username":
        "g7tPQQwfa5fDdP8BcMDSbQ==.g7tPQQwfa5fDdP8BcMDSbQ==.UCmnIJrqxa4rceoAKJUKZA==",
        "password": "g7tPQQwfa5fDdP8BcMDSbQ==.UCmnIJrqxa4rceoAKJUKZA=="
        },
    );
    print(respPost.body);
}
```
