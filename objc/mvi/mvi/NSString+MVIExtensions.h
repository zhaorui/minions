//
//  NSString+MVIExtensions.h
//  mvi
//
//  Created by 赵睿 on 3/29/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (MVIExtensions)

+ (NSString *)stringWithFileSystemRepresentation:(const char *)str;
- (NSString *)replacingWithPattern:(NSString *)pattern
                      withTemplate:(NSString *)withTemplate
                             error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
