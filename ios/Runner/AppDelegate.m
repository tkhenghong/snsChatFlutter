#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"


@import UIKit;
@import Firebase;
@import GoogleMaps;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
   // Configure Firebase
  // ------------------
   if(![FIRApp defaultApp]){
      [FIRApp configure];
  }

  // Google Maps Key
  [GMSServices provideAPIKey:@""];

  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
