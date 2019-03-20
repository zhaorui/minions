//
//  Basic.h
//  RumtimeTest
//
//  Created by 赵睿 on 2/27/19.
//  Copyright © 2019 com.alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Objc_MsgSendTester : NSObject

// 无参数 无返回值
- (void)noArgumentsAndNoReturnValue;

// 带一个参数 无返回值
- (void)hasArguments:(NSString *)arg;

// 无参数 有返回值
- (NSString *)noArgumentsButReturnValue;

// 带两个参数 有返回值
- (int)hasArguments:(NSString *)arg andReturnValue:(int)arg1;

// 带参数 返回值是浮点类型
- (float)hasAruguments:(NSString *)arg andReturnFloat:(float)arg1;

@end

NS_ASSUME_NONNULL_END
