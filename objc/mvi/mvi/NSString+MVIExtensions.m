//
//  NSString+MVIExtensions.m
//  mvi
//
//  Created by 赵睿 on 3/29/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import "NSString+MVIExtensions.h"

@implementation NSString (MVIExtensions)

+ (NSString *)stringWithFileSystemRepresentation:(const char *)str;
{
    // 2004-01-16: I'm don't understand why we need to pass in the length.
    return [[NSFileManager defaultManager] stringWithFileSystemRepresentation:str length:strlen(str)];
}

- (NSString *)replacingWithPattern:(NSString *)pattern
                      withTemplate:(NSString *)withTemplate
                             error:(NSError **)error {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:error];
    return [regex stringByReplacingMatchesInString:self
                                           options:0
                                             range:NSMakeRange(0, self.length)
                                      withTemplate:withTemplate];
}

@end
