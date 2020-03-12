import Flutter
import UIKit

public class SwiftNativeHttpPlugin: NSObject, FlutterPlugin {

  var session = URLSession(configuration: URLSessionConfiguration.default)

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native_http", binaryMessenger: registrar.messenger())
    let instance = SwiftNativeHttpPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "native_http/request":
        let arguments = (call.arguments as? [String : AnyObject])
        
        let url = arguments!["url"] as! String
        let method = arguments!["method"] as! String
        let headers = arguments!["headers"] as! Dictionary<String, String>
        let body = arguments!["body"] as! Dictionary<String, String>
        handleCall(url:url, method:method,headers:headers, body:body, result:result)
    default:
        result("Not implemented");
    }
  }
    
    func handleCall(url: String, method: String, headers:Dictionary<String, String>, body:Dictionary<String, String>, result:@escaping FlutterResult){
        switch method {
        case "GET":
            return getCall(url:url, headers:headers, body:body, result: result);
        default:
            return dataCall(url:url, method: method, headers:headers, body:body, result: result);
        }
    }
    
    func getCall(url: String, headers:Dictionary<String, String>, body:Dictionary<String, String>, result: @escaping FlutterResult) {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        headers.forEach {(key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let task = session.dataTask(with: request) {( data, response, error) in
            if(error != nil){
               result(FlutterError (code:"400", message:error?.localizedDescription, details:nil))
               return
            }
            let responseString = String(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            let httpResponse = response as? HTTPURLResponse
            let responseCode = httpResponse?.statusCode
            
            var r :Dictionary = Dictionary<String, Any>()
            r["code"]  = responseCode;
            r["body"]  = responseString;
            result(r);
        }
        task.resume()
    }
    
    func dataCall(url: String, method: String, headers:Dictionary<String, String>, body:Dictionary<String, String>, result: @escaping FlutterResult) {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        
        headers.forEach {(key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(body) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                request.httpBody = jsonString.data(using: .utf8)
            }
        }
    
        let task = session.dataTask(with: request) {( data, response, error) in
            if(error != nil){
                result(FlutterError (code:"400", message:error?.localizedDescription, details:nil))
                return
            }
            let responseString = String(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            let httpResponse = response as? HTTPURLResponse
            let responseCode = httpResponse?.statusCode
            
            var r :Dictionary = Dictionary<String, Any>()
            r["code"]  = responseCode;
            r["body"]  = responseString;
            result(r);
        }
        task.resume()
    }
}
