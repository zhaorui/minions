//
//  MemoConfig.h
//  memo
//
//  Created by 赵睿 on 3/20/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemoConfig : NSObject <NSSecureCoding>

@property (copy, nonatomic) NSString* location;
@property (readonly, nonatomic) NSString* path;

+ (id)sharedConfig;

@end

NS_ASSUME_NONNULL_END
