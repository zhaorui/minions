//
//  MviConfig.h
//  mvi
//
//  Created by 赵睿 on 3/29/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MviConfig : NSObject

@property (nonatomic, copy) NSString* patternRegex;
@property (nonatomic, copy) NSString* templateRegex;

+ (id)sharedConfig;

@end

NS_ASSUME_NONNULL_END
