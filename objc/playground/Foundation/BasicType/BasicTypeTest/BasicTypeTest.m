//
//  BasicTypeTest.m
//  BasicTypeTest
//
//  Created by 赵睿 on 2/21/19.
//  Copyright © 2019 com.alibaba. All rights reserved.
//

#import <XCTest/XCTest.h>

typedef NS_ENUM(NSInteger, ALEPASSSessionManagerErrorCode) {
    ALEPASSSessionManagerErrorUnknown = -1,
    ALEpassSessionManagerErrorDeviceNotFound = -1001, //device log out
    ALEpassSessionManagerErrorAccessTokenOudated = -1007,
    ALEPASSSessionManagerErrorNoP12Return = 1,
    ALEPASSSessionManagerErrorImportP12Failure,
    ALEPASSSessionManagerErrorRemoveP12Failure,
};


@interface BasicTypeTest : XCTestCase

@property (strong, nonatomic) NSDictionary* dict;
@property (strong, nonatomic) NSMutableDictionary* mdict;

@end

@implementation BasicTypeTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.dict = @{@"name": @"zhaorui",
                  @"age" : @(29),
                  @"errCode" : @(-1007)
                  };
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

#pragma mark - NSEnum

- (void)testEnum {
    XCTAssertTrue([@(-1007) isEqualToNumber:@(ALEpassSessionManagerErrorAccessTokenOudated)]);
    XCTAssertTrue([self.dict[@"errCode"] isEqualToNumber:@(ALEpassSessionManagerErrorAccessTokenOudated)]);
}

#pragma mark - NSDictionary

- (void)testDictionaryValueEqualToNumber {
    XCTAssertEqual([self.dict[@"age"] isEqualToNumber:@(29)], YES);
}

- (void)testDictionaryValueEqualToString {
    XCTAssertEqual([self.dict[@"age"] isEqualTo:@"29"], NO);
}

#pragma mark - NSMutableDictionary


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
