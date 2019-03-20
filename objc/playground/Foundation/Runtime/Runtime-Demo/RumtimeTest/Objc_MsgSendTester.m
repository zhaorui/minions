//
//  Basic.m
//  RumtimeTest
//
//  Created by 赵睿 on 2/27/19.
//  Copyright © 2019 com.alibaba. All rights reserved.
//

#import "Objc_MsgSendTester.h"

@implementation Objc_MsgSendTester

// 无参数 无返回值
- (void)noArgumentsAndNoReturnValue
{
    NSLog(@"方法名：%s", __FUNCTION__);
}

// 带一个参数 无返回值
- (void)hasArguments:(NSString *)arg
{
    NSLog(@"方法名：%s, 参数：%@", __FUNCTION__, arg);
}

// 无参数 有返回值
- (NSString *)noArgumentsButReturnValue
{
    NSLog(@"方法名：%s, 返回值：%@", __FUNCTION__, @"不带参数，但是带有返回值");
    return @"noArgumentsButReturnValue SUCCESS";
}

// 带两个参数 有返回值
- (int)hasArguments:(NSString *)arg andReturnValue:(int)arg1
{
    NSLog(@"方法名：%s, 参数：%@, 返回值：%d", __FUNCTION__, arg, arg1);
    return arg1;
}

// 带参数 返回值是浮点类型
- (float)hasAruguments:(NSString *)arg andReturnFloat:(float)arg1 {
    NSLog(@"方法名：%s, 参数：%@, 返回值：%f", __FUNCTION__, arg, arg1);
    return arg1;
}

@end
