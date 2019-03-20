//
//  TaskManagementDemoTests.m
//  TaskManagementDemoTests
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TaskManagementDemoTests : XCTestCase

@end

@interface TaskManagementDemoTests () <NSUserNotificationCenterDelegate>

@property (strong, nonatomic) XCTestExpectation* notificationPresented;

@end

@implementation TaskManagementDemoTests

- (void)setUp {
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    self.notificationPresented = [[XCTestExpectation alloc] initWithDescription:@"expect receive notification"];
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSimpleUserNotification {
    
    NSUserNotification* n = [NSUserNotification new];
    n.title = NSLocalizedString(@"Found Aillang Upgrade Issue", @"Notification Title");
    n.informativeText = NSLocalizedString(@"Please kindly fix it and use the latest version", @"Notification Information");
    n.identifier = @"com.alibaba.alilang.upgrade.issue.found";
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:n];
    //[XCTWaiter waitForExpectations:self.notificationPresented timeout:5.0];
    [self waitForExpectations:@[self.notificationPresented] timeout:5.0];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
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
    
}

@end

