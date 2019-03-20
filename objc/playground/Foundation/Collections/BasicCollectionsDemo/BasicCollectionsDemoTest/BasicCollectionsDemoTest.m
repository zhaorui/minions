//
//  BasicCollectionsDemoTest.m
//  BasicCollectionsDemoTest
//
//  Created by 赵睿 on 3/2/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BasicCollectionsDemoTest : XCTestCase

@property (strong, nonatomic) NSDictionary* dict;
@property (strong, nonatomic) NSMutableDictionary* mdict;

@end

@implementation BasicCollectionsDemoTest

- (void)setUp {
    self.dict = @{@"name":@"zhaorui", @"age":@(29), @"male":@(YES), @"country":[NSNull null]};
    self.mdict = [self.dict mutableCopy];
}

- (void)testMuatableDictionary {
    NSInteger c = [self.mdict count];
    self.mdict[@"name"] = nil;
    self.mdict[@"kidding"] = self.mdict[@"gg"];
    c = [self.mdict count];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
