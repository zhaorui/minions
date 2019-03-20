//
//  TaskManagementDemoUITests.m
//  TaskManagementDemoUITests
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <XCTest/XCTest.h>

static NSString* const simpleBannerNotification = @"simple.banner.notification";
static NSString* const simpleAlertNotification = @"simple.alert.notification";
static NSString* const mutipleActionsNotification = @"multiple.actions.notification";

@interface TaskManagementDemoUITests : XCTestCase

@end

@interface TaskManagementDemoUITests () <NSUserNotificationCenterDelegate>

@property (strong, nonatomic) NSUserNotification* notification;
@property (strong, nonatomic) XCTestExpectation* notificationPresented;
@property (strong, nonatomic) XCTestExpectation* notificationActivated;

@end

@implementation TaskManagementDemoUITests

- (void)setUp {

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}



- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testSimpleUserNotification {
    XCUIApplication* app = [[XCUIApplication alloc] init];
    XCUIElementQuery *menuBarsQuery = app.menuBars;
    [menuBarsQuery.menuBarItems[@"通知"] click];
    [menuBarsQuery.menuBarItems[@"通知"].menus.menuItems[@"条幅"]  click];
    
    //TODO: How to check notification is pop-up?
}

// You need to define the key NSUserNotificationAlertStyle in Info.plist with with the value alert
- (void)testUserNotificationWithActionButton {
    self.notificationPresented = [[XCTestExpectation alloc] initWithDescription:@"expect receive notification"];
    self.notificationActivated = [[XCTestExpectation alloc] initWithDescription:@"expect user click the notification"];
    
    self.notification.identifier = simpleAlertNotification;
    self.notification.hasActionButton = YES;
    self.notification.actionButtonTitle = NSLocalizedString(@"Fix_Now", @"Fix upgrade issue immediately");
    self.notification.otherButtonTitle = NSLocalizedStringFromTable(@"Fix_Later", @"Localizable", @"fix it later");
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:self.notification];
    
    [self waitForExpectations:@[self.notificationPresented] timeout:5.0];
    [self waitForExpectations:@[self.notificationActivated] timeout:10.0];
}

// You need to define the key NSUserNotificationAlertStyle in Info.plist with with the value alert
- (void)testUserNotificationWithMultipleActionButton {
    self.notificationPresented = [[XCTestExpectation alloc] initWithDescription:@"expect receive notification"];
    self.notificationActivated = [[XCTestExpectation alloc] initWithDescription:@"expect user click the notification"];
    
    self.notification.identifier = mutipleActionsNotification;
    self.notification.hasActionButton = YES;
    self.notification.actionButtonTitle = NSLocalizedString(@"Fix_Now", @"Fix upgrade issue immediately");
    self.notification.otherButtonTitle = NSLocalizedStringFromTable(@"Fix_Later", @"Localizable", @"fix it later");
    [self.notification setValue:@[@"Test", @"Test1"] forKey:@"_alternateActionButtonTitles"];
    [self.notification setValue:@YES forKey:@"_alwaysShowAlternateActionMenu"];
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:self.notification];
    
    [self waitForExpectations:@[self.notificationPresented] timeout:5.0];
    [self waitForExpectations:@[self.notificationActivated] timeout:10.0];
    
}

#pragma mark - NSUserNotificationCenterDelegate

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

-(void)userNotificationCenter:(NSUserNotificationCenter *)center
       didDeliverNotification:(NSUserNotification *)notification {
    [self.notificationPresented fulfill];
}

-(void)userNotificationCenter:(NSUserNotificationCenter *)center
      didActivateNotification:(NSUserNotification *)notification {
    if ([notification.identifier isEqualToString:simpleAlertNotification]) {
        [self.notificationActivated fulfill];
    } else if ([notification.identifier isEqualToString:mutipleActionsNotification]) {
        NSLog(@"clearable: %@", [notification valueForKey:@"_clearable"]);
        NSLog(@"activationType: %@", [notification valueForKey:@"activationType"]);
        NSLog(@"storageID: %@", [notification valueForKey:@"_storageID"]);
        NSLog(@"style: %@", [notification valueForKey:@"_style"]);
        NSLog(@"dismissAfterDuration: %@", [notification valueForKey:@"_dismissAfterDuration"]);
        NSLog(@"response: %@", [notification valueForKey:@"response"]);
        [self.notificationActivated fulfill];
    }
}



@end
