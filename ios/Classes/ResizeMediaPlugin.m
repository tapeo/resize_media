#import "ResizeMediaPlugin.h"
#if __has_include(<resize_media/resize_media-Swift.h>)
#import <resize_media/resize_media-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "resize_media-Swift.h"
#endif

@implementation ResizeMediaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftResizeMediaPlugin registerWithRegistrar:registrar];
}
@end
