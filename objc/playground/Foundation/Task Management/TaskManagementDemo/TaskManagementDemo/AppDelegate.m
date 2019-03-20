//
//  AppDelegate.m
//  TaskManagementDemo
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import "AppDelegate.h"

NSString* const title = @"Found Aillang Upgrade Issue";
NSString* const subTitle = @"";
NSString* const message = @"Please kindly fix it and use the latest version";
NSString* const actionTitle =@"Run_Now";
NSString* const actionTitle1 = @"";
NSString* const actionTitle2 = @"";
NSString* const otherActionTitle = @"Run_Later";

@interface AppDelegate () <NSUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"%@", NSLocalizedString(@"Fix_Now", @"fix the upgrade issue right now"));
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


#pragma mark - Menu Item Event Handler
- (IBAction)showBanner:(id)sender {
    NSUserNotification* bannerNotification = [NSUserNotification new];
    bannerNotification.title = NSLocalizedString(title, @"Notification Title");
    bannerNotification.informativeText = NSLocalizedString(message, @"Notification Information");
    bannerNotification.identifier = @"banner.notification";
    bannerNotification.hasActionButton = NO;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:bannerNotification];
}


- (IBAction)showAlert:(id)sender {
    NSUserNotification* alertNotification = [NSUserNotification new];
    alertNotification.title = NSLocalizedString(title, @"Notification Title");
    alertNotification.informativeText = NSLocalizedString(message, @"Notification Information");
    alertNotification.identifier = @"alert.notification";
    alertNotification.actionButtonTitle = NSLocalizedString(actionTitle, @"Action Title");
    alertNotification.otherButtonTitle = NSLocalizedString(otherActionTitle, @"Other Title");
    alertNotification.hasActionButton = YES;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:alertNotification];
}

- (IBAction)showMultipleActionsAlert:(id)sender {
    NSUserNotification* multipleActionsNotification = [NSUserNotification new];
    multipleActionsNotification.title = NSLocalizedString(title, @"Notification Title");
    multipleActionsNotification.informativeText = NSLocalizedString(message, @"Notification Information");
    multipleActionsNotification.identifier = @"alert.notification";
    multipleActionsNotification.actionButtonTitle = NSLocalizedString(actionTitle, @"Action Title");
    multipleActionsNotification.otherButtonTitle = NSLocalizedString(otherActionTitle, @"Other Title");
    multipleActionsNotification.hasActionButton = YES;
    [multipleActionsNotification setValue:[NSNumber numberWithBool:YES] forKey:@"_alwaysShowAlternateActionMenu"];
    multipleActionsNotification.additionalActions = @[ [NSUserNotificationAction actionWithIdentifier:@"action1" title:@"action1"],
                                             [NSUserNotificationAction actionWithIdentifier:@"action2" title:@"action2"]
                                             ];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:multipleActionsNotification];
    
}


#pragma mark - NSUserNotificationDelegate
-(void)userNotificationCenter:(NSUserNotificationCenter *)center didDeliverNotification:(NSUserNotification *)notification {
    if ([notification.identifier isEqualToString:@"banner.notification"]) {
        NSLog(@"banner.notification deliver");
    } else if ([notification.identifier isEqualToString:@"alert.notification"]) {
        NSLog(@"alert.notification deliver");
    }
}

-(void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    if ([notification.identifier isEqualToString:@"banner.notification"]) {
        NSLog(@"banner activated");
    } else if ([notification.identifier isEqualToString:@"alert.notification"]) {
        NSLog(@"alert activated");
        NSLog(@"id: %@, title: %@", notification.additionalActivationAction.identifier, notification.additionalActivationAction.title);
    }
}

-(BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

@end
