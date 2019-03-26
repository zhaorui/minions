//
//  main.m
//  memo
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemoConfig.h"

#include "cache.h"


#define MEMO_BASE_VERSION "0.1.0 (64 bit)"

#ifdef DEBUG
#define MEMO_VERSION MEMO_BASE_VERSION " (Debug version compiled " __DATE__ " " __TIME__ ")"
#else
#define MEMO_VERSION MEMO_BASE_VERSION
#endif



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        int result;
        [MemoConfig sharedConfig];
        result = cmd_main(argc, argv);
    }
    return 0;
}
