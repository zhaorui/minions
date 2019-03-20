//
//  main.m
//  memo
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <getopt.h>
#include <sysexits.h>

#define MEMO_BASE_VERSION "0.1.0 (64 bit)"

#ifdef DEBUG
#define MEMO_VERSION MEMO_BASE_VERSION " (Debug version compiled " __DATE__ " " __TIME__ ")"
#else
#define MEMO_VERSION MEMO_BASE_VERSION
#endif

void print_usage(void)
{
    fprintf(stderr,
            "memo %s\n"
            "Usage: memo <command> [options]\n"
            "\n"
            "  where commands are:\n"
            "        list, ls       list top-level memo entry"
            "  where options are:\n"
            "        -h, --help     show instance variable offsets\n"
            ,
            MEMO_VERSION
            );
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSString* configDir = [NSHomeDirectory() stringByAppendingPathComponent:@".config"];
        NSString* memo_config = [configDir stringByAppendingPathComponent:@"memo"];
        BOOL foundConfig =[[NSFileManager defaultManager] fileExistsAtPath:memo_config];
        if (!foundConfig) {
            
        }
        
        if (argc < 2 || strlen(argv[1]) <= 0) {
            print_usage();
            exit(EX_SOFTWARE);
        }
        
        NSString* cmd = [NSString stringWithUTF8String:argv[1]];
        
        int ch;
        BOOL errorFlag = NO;
        struct option longopts[] = {
            { "help", no_argument, NULL, 'h'},
            { NULL, 0, NULL, 0 },
        };
        
        while ( (ch = getopt_long(argc, (char*const*)argv, "h", longopts, NULL)) != -1) {
            switch (ch) {
                case 'h':
                    break;
                case '?':
                default:
                    errorFlag = YES;
                    break;
            }
        }
        
        if ([cmd isEqualToString:@"list"] || [cmd isEqualToString:@"ls"]) {
            
        }
    }
    return 0;
}
