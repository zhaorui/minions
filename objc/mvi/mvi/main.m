//
//  main.m
//  mvi
//  mvi means mv improved, it's used to change mounts of filenames quickly
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+MVIExtensions.h"
#import "MviConfig.h"

#include <getopt.h>

static void mvURL(NSURL* entryURL) {
    NSMutableArray* parentEntryComponents = [[entryURL pathComponents] mutableCopy];
    [parentEntryComponents removeLastObject];
    
    MviConfig* config = [MviConfig sharedConfig];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSString* itemName = [[entryURL pathComponents] lastObject];
    NSString* newName = [itemName replacingWithPattern:[config patternRegex]
                                          withTemplate:[config templateRegex]
                                                 error:nil];
    [parentEntryComponents addObject:newName];
    NSURL* newURL = [NSURL fileURLWithPathComponents:parentEntryComponents];
    [fileMgr moveItemAtURL:entryURL toURL:newURL error:nil];
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int ch;
        BOOL errorFlag = NO;

        struct option longopts[] = {
            { "from", no_argument, NULL, 'f'},
            { "to", no_argument, NULL, 't'},
            { NULL, 0, NULL, 0 },
        };
        
        MviConfig* config = [MviConfig sharedConfig];
        while ( (ch = getopt_long(argc, (char*const*)argv, "f:t:", longopts, NULL)) != -1) {
            switch (ch) {
                case 'f':
                    [config setPatternRegex:[NSString stringWithUTF8String:optarg]];
                    break;
                case 't':
                    [config setTemplateRegex:[NSString stringWithUTF8String:optarg]];
                    break;
                default:
                    errorFlag = YES;
                    break;
            }
        }
        
        
        if (optind < argc) {
            NSFileManager* fileMgr = [NSFileManager defaultManager];
            BOOL isD = NO;
            BOOL isE = NO;
            NSString *path = [NSString stringWithFileSystemRepresentation:argv[optind]];
            NSURL* pathURL = [NSURL URLWithString:path];
            isE = [fileMgr fileExistsAtPath:path isDirectory:&isD];
            if (isE) {
                if (isD) {
                    NSDirectoryEnumerationOptions options = NSDirectoryEnumerationSkipsHiddenFiles|
                    NSDirectoryEnumerationSkipsPackageDescendants;
                    NSDirectoryEnumerator* urlEnum = [fileMgr enumeratorAtURL: pathURL
                                                   includingPropertiesForKeys:nil
                                                                      options:options
                                                                 errorHandler:nil];
                    
                    for (NSURL* url in urlEnum) {
                        mvURL(url);
                    }
                } else {
                    mvURL([NSURL fileURLWithPath:path]);
                }
            } else {
                fprintf(stderr, "%s is not exist.\n", [path UTF8String]);
            }
        }
    }
    return 0;
}
