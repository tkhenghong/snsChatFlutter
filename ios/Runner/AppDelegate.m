#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#include "FlutterDownloaderPlugin.h" // For flutter_downloader plugin

@implementation AppDelegate

// For flutter_downloader plugin
void registerPlugins(NSObject<FlutterPluginRegistry>* registry) {
  if (![registry hasPlugin:@"FlutterDownloaderPlugin"]) {
     [FlutterDownloaderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterDownloaderPlugin"]];
  }
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  [FlutterDownloaderPlugin setPluginRegistrantCallback:registerPlugins]; // For flutter_downloader plugin
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
