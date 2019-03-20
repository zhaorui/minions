//
//  BundleDemoTests.m
//  BundleDemoTests
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BundleDemoTests : XCTestCase

@end

@implementation BundleDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testBundle {
    NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString* bundleID =  [[NSBundle mainBundle] bundleIdentifier];
    NSURL* bundleURL =  [[NSBundle mainBundle] bundleURL];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
