//
//  RumtimeTest.m
//  RumtimeTest
//
//  Created by 赵睿 on 2/27/19.
//  Copyright © 2019 com.alibaba. All rights reserved.
//
#import "Objc_MsgSendTester.h"
#import <XCTest/XCTest.h>
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface RumtimeTest : XCTestCase

@end

@implementation RumtimeTest

- (void)setUp {
    NSLog(@"setting up test environment...");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSelector {
    id nilObject;
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wall"
        XCTAssertTrue(sel_isEqual(@selector(hello:world:), NSSelectorFromString(@"hello:world:")));
        XCTAssertTrue(sel_isEqual(@selector(description), sel_getUid("description")));
        XCTAssertEqual(0, NSSelectorFromString(nilObject));
    #pragma clang diagnostic pop
}

- (void)testSendingMessage {
    // 1、创建对象
    // 给'Simple'类发送消息，创建对象，这句话等同于 Simple *test = [Simple alloc];
    Objc_MsgSendTester *test = ((Objc_MsgSendTester * (*)(id,SEL)) objc_msgSend)((id)[Objc_MsgSendTester class], @selector(alloc));
    
    // 2、初始化对象
    // 给'test'对象发送消息进行初始化，这句话等同于 [test init];
    test = ((Objc_MsgSendTester *(*)(id,SEL))objc_msgSend)((id)test, @selector(init));
    NSLog(@"test:%@", test);
    
    // 3、调用无参无返回值方法
    ((void(*)(id,SEL))objc_msgSend)((id)test, @selector(noArgumentsAndNoReturnValue));
    
    // 4、调用带一个参数但无返回值的方法
    ((void(*)(id,SEL,NSString *))objc_msgSend)((id)test, @selector(hasArguments:), @"带一参数但是没有返回值");
    
    // 5、调用没有参数有返回值
    NSString *returnStr = ((NSString * (*) (id, SEL))objc_msgSend)((id)test, @selector(noArgumentsButReturnValue));
    XCTAssertTrue([returnStr isKindOfClass:[NSString class]] && [returnStr length]);
    
    // 6、有返回值有参数
    int returnInt = ((int (*) (id, SEL, NSString *, int))objc_msgSend)((id)test, @selector(hasArguments:andReturnValue:), @"参数1", 1024);
    XCTAssertTrue(returnInt == 1024);
    
    // 7、objc_msgSend_fpret 返回浮点类型的方法
    float returnFloat = ((float (*) (id, SEL, NSString *, float))objc_msgSend_fpret)((id)test, @selector(hasAruguments:andReturnFloat:), @"参数1", 3.141f);
    XCTAssertTrue(fabs(returnFloat-3.141) < 0.001);
    
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
