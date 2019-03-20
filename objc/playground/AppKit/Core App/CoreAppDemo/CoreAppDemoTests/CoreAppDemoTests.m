//
//  CoreAppDemoTests.m
//  CoreAppDemoTests
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface CoreAppDemoTests : XCTestCase

@end

@implementation CoreAppDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testWorkspace {
    NSString *path = [[NSWorkspace sharedWorkspace] fullPathForApplication:@"Twitter"];
    XCTAssertNil(path);
    
    path = [[NSWorkspace sharedWorkspace] fullPathForApplication:@"HammerSpoon"];
    XCTAssertTrue([path length]);
    
    path = [[NSWorkspace sharedWorkspace] fullPathForApplication:@"AliEntSafe"];
    XCTAssertTrue([path length]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
