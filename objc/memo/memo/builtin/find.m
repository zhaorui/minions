//
//  find.m
//  memo
//
//  Created by 赵睿 on 3/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemoConfig.h"

static BOOL match(NSString* str, NSArray* argvs) {
    for (NSString* item in argvs) {
        if ([str rangeOfString:item].length) {
            return YES;
        }
    }
    return NO;
}


int cmd_find(int argc, const char **argv, const char *prefix)
{
    NSMutableArray* items = [NSMutableArray new];
    for (int i = 1; i < argc; i++) {
        [items addObject:[NSString stringWithUTF8String:argv[i]]];
    }
    
    NSString* memoRoot = [[[MemoConfig sharedConfig] location] stringByStandardizingPath];
    NSURL* memoRootURL = [NSURL URLWithString:memoRoot];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    printf("finding in %s ...\n", [memoRoot UTF8String]);
    
    NSDirectoryEnumerationOptions options = NSDirectoryEnumerationSkipsHiddenFiles|
    NSDirectoryEnumerationSkipsPackageDescendants;
    NSDirectoryEnumerator* urlEnum = [fileMgr enumeratorAtURL: memoRootURL
                                   includingPropertiesForKeys:nil
                                                      options:options
                                                 errorHandler:nil];
    
    for (NSURL* url in urlEnum) {
        if (match([url absoluteString], items)) {
            printf("%s\n", [url fileSystemRepresentation]);
        }
    }
    
    return 0;
}
