//
//  FiltersSortingDemoTests.m
//  FiltersSortingDemoTests
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UserProfile.h"


@interface FiltersSortingDemoTests : XCTestCase

@property (strong, nonatomic) NSNumber* numberOneTwoThree;
@property (copy, nonatomic) NSString* message;
@property (strong, nonatomic) NSArray* numberArrayOneToSix;
@property (strong, nonatomic) UserProfile* profile;

@end

@implementation FiltersSortingDemoTests

- (void)setUp {
    self.numberOneTwoThree = @(123);
    self.message = @"I love you";
    self.numberArrayOneToSix = @[@(1),@(2),@(3),@(4),@(5),@(6)];
    self.profile = [UserProfile personWithName:@"zhaorui"
                                           age:29
                                        gender:GenderMale
                                         phone:@"13805737120"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF = 123"];
    XCTAssertTrue([predicate evaluateWithObject:self.numberOneTwoThree]);
    
    predicate = [NSPredicate predicateWithFormat:@"SELF BETWEEN {100, 200}"];
    XCTAssertTrue([predicate evaluateWithObject:self.numberOneTwoThree]);
    
    predicate = [NSPredicate predicateWithFormat:@"SELF > 2 && SELF < 5"];
    NSArray* filteredArray = [self.numberArrayOneToSix filteredArrayUsingPredicate:predicate];
    NSArray* expectedArray = @[@(3), @(4)];
    XCTAssertTrue([filteredArray isEqualToArray:expectedArray]);
    
    NSString *regex = @"^[1][3-8]\\d{9}$";
    predicate = [NSPredicate predicateWithFormat:@"phoneNumber MATCHES %@", regex];
    XCTAssertTrue([predicate evaluateWithObject:self.profile]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
