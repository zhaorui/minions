//
//  PreferencesDemoTests.m
//  PreferencesDemoTests
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface PreferencesDemoTests : XCTestCase

@end

@implementation PreferencesDemoTests

- (void)setUp {
    [[NSUserDefaults standardUserDefaults] setValue:@(17) forKey:@"id"];
    [[NSUserDefaults standardUserDefaults] setInteger:17 forKey:@"age"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testNSUserDefaults {
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
