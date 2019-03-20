//
//  DataAndTimeDemoTests.m
//  DataAndTimeDemoTests
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface DataAndTimeDemoTests : XCTestCase

@end

@implementation DataAndTimeDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testDate {
    
    double time_now = [[NSDate date] timeIntervalSince1970];
    NSString* update_time = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    NSLog(@"%f %lf %lf %@", FLT_MAX, DBL_MAX, time_now, update_time);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
