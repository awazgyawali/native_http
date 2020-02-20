#import "NativeHttpPlugin.h"
#if __has_include(<native_http/native_http-Swift.h>)
#import <native_http/native_http-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "native_http-Swift.h"
#endif

@implementation NativeHttpPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativeHttpPlugin registerWithRegistrar:registrar];
}
@end
