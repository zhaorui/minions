//
//  AppDelegate.m
//  BridgingSwiftDemo
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//
// Practice of https://developer.apple.com/documentation/swift/imported_c_and_objective-c_apis/importing_swift_into_objective-c

#import "AppDelegate.h"
#import "BridgingSwiftDemo-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    SwfitDemoClass* demoClass = [SwfitDemoClass new];
    MessageCode code = MessageCodeLoginReq;
    
    LogSeverity severity = LogSeverityInfo;
    
    ConnectivityStatus status = ConnectivityStatusWifi;
    
    InventoryItemType type = InventoryItemTypeVial;
    
    
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
