//
//  home.m
//  memo
//
//  Created by 赵睿 on 4/8/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemoConfig.h"

int cmd_home(int argc, const char **argv, const char *prefix)
{
    NSString* memoLoc = [[[MemoConfig sharedConfig] location] stringByStandardizingPath];
    printf("%s\n", [memoLoc UTF8String]);
    return 0;
}
