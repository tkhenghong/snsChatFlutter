#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"


@import UIKit;
@import Firebase;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
   // Configure Firebase
  // ------------------
   if(![FIRApp defaultApp]){
      [FIRApp configure];
  }
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
