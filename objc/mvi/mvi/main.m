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

#if defined(__HP_cc) && (__HP_cc >= 61000)
#define NORETURN __attribute__((noreturn))
#define NORETURN_PTR
#elif defined(__GNUC__) && !defined(NO_NORETURN)
#define NORETURN __attribute__((__noreturn__))
#define NORETURN_PTR __attribute__((__noreturn__))
#elif defined(_MSC_VER)
#define NORETURN __declspec(noreturn)
#define NORETURN_PTR
#else
#define NORETURN
#define NORETURN_PTR
#ifndef __GNUC__
#ifndef __attribute__
#define __attribute__(x)
#endif
#endif
#endif

static void vreportf(const char *prefix, const char *err, va_list params)
{
    char msg[4096];
    char *p;
    
    vsnprintf(msg, sizeof(msg), err, params);
    for (p = msg; *p; p++) {
        if (iscntrl(*p) && *p != '\t' && *p != '\n')
            *p = '?';
    }
    fprintf(stderr, "%s%s\n", prefix, msg);
}

static NORETURN void usage_builtin(const char *err, va_list params)
{
    vreportf("usage: ", err, params);
    
    /*
     * Currently, the (err, params) are usually just the static usage
     * string which isn't very useful here.  Usually, the call site
     * manually calls fprintf(stderr,...) with the actual detailed
     * syntax error before calling usage().
     *
     * TODO It would be nice to update the call sites to pass both
     * the static usage string and the detailed error message.
     */
    
    exit(129);
}

static void NORETURN usagef(const char *err, ...)
{
    va_list params;
    
    va_start(params, err);
    usage_builtin(err, params);
    va_end(params);
}

void NORETURN usage(const char *err)
{
    usagef("%s", err);
}

const char mvi_usage_string[] =
"mvi <-f|--from> <-t|--to> <dir|file>";

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
        
        if (errorFlag) {
            usage(mvi_usage_string);
        }
        
        if (![config.patternRegex length] || ![config.templateRegex length]) {
            usage(mvi_usage_string);
        }
        
        if (optind < argc) {
            NSFileManager* fileMgr = [NSFileManager defaultManager];
            BOOL isD = NO;
            BOOL isE = NO;
            NSString *path = [NSString stringWithFileSystemRepresentation:argv[optind]];
            NSURL* pathURL = [NSURL URLWithString:[path stringByStandardizingPath]];
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
                usage(mvi_usage_string);
            }
        }
    }
    return 0;
}
