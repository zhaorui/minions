//
//  MviConfig.m
//  mvi
//
//  Created by 赵睿 on 3/29/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import "MviConfig.h"

@implementation MviConfig

+(id)sharedConfig {
    static dispatch_once_t onceToken;
    static MviConfig* _config;
    dispatch_once(&onceToken, ^{
        _config = [MviConfig new];
        _config.patternRegex = nil;
        _config.templateRegex = nil;
    });
    return _config;
}

@end
