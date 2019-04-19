//
//  find.m
//  memo
//
//  Created by 赵睿 on 3/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemoConfig.h"
#import "NSURL+Convience.h"

#include "apue.h"
#include "common.h"
#include "color.h"

static BOOL match(NSString* str, NSArray* argvs) {
    for (NSString* item in argvs) {
        if ([str rangeOfString:item].length) {
            return YES;
        }
    }
    return NO;
}

static void updateCursor(NSArray<NSURL*>* items, int index) {
    for (int i = 0; i < [items count]; i++) {
        NSURL* item = [items objectAtIndex:i];
        if (index == i) {
            color_fprintf_ln(stdout, GIT_COLOR_BG_RED, "%s", [item fileSystemRepresentation]);
        } else {
            if ([item isFolder]) {
                color_fprintf_ln(stdout, GIT_COLOR_BLUE, "%s", [item fileSystemRepresentation]);
            } else {
                printf("%s\n", [item fileSystemRepresentation]);
            }
        }
    }
}

int cmd_find(int argc, const char **argv, const char *prefix)
{
    tty_cbreak(STDIN_FILENO);
    
    NSMutableArray* items = [NSMutableArray new];
    for (int i = 1; i < argc; i++) {
        [items addObject:[NSString stringWithUTF8String:argv[i]]];
    }
    
    NSString* memoRoot = [[[MemoConfig sharedConfig] location] stringByStandardizingPath];
    NSURL* memoRootURL = [NSURL URLWithString:memoRoot];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    printf("search in directory %s ...\n", [memoRoot UTF8String]);
    
    NSDirectoryEnumerationOptions options = NSDirectoryEnumerationSkipsHiddenFiles|
    NSDirectoryEnumerationSkipsPackageDescendants;
    NSDirectoryEnumerator* urlEnum = [fileMgr enumeratorAtURL: memoRootURL
                                   includingPropertiesForKeys:nil
                                                      options:options
                                                 errorHandler:nil];
    
    NSMutableArray* urls = [NSMutableArray new];
    for (NSURL* url in urlEnum) {
        if (match([url absoluteString], items)) {
            [urls addObject:url];
        }
    }
    
    if ([urls count] == 0) {
        die("keyword is not found");
    }
    
    int cursor = 0;
    updateCursor(urls, cursor);
    int control;
    while ((control = getchar()) != 'q') {
        switch (control) {
            case 'j':
                // set cursor back to the first menu item
                printf("\033[%ldA", [urls count]);
                // repaint
                cursor = (cursor+1)%[urls count];
                updateCursor(urls, cursor);
                break;
            case 'k':
                // set cursor back to the first menu item
                printf("\033[%ldA", [urls count]);
                //repaint
                if (cursor == 0) {
                    cursor = (int)[urls count];
                }
                cursor--;
                updateCursor(urls, cursor);
                break;
            case 'c': {
                NSURL* pickedURL = [urls objectAtIndex:cursor];
                if (![pickedURL isFolder]) {
                    char ** vim_argv = malloc(sizeof(char*) * 3);
                    vim_argv[0] = "cat";
                    vim_argv[1] = xstrdup([pickedURL fileSystemRepresentation]);
                    vim_argv[2] = NULL;
                    execvp("/bin/cat", vim_argv);
                    die("cat execve");
                }
                break;
            }
            case '\n': {
                NSURL* pickedURL = [urls objectAtIndex:cursor];
                if (![pickedURL isFolder]) {
                    char ** vim_argv = malloc(sizeof(char*) * 3);
                    vim_argv[0] = "vim";
                    vim_argv[1] = xstrdup([[urls objectAtIndex:cursor] fileSystemRepresentation]);
                    vim_argv[2] = NULL;
                    execvp("/usr/bin/vim", vim_argv);
                    die("vim execve");
                }
                break;
            }
            default:
                die("unknown key is pressed");
                break;
        }
    }
    
    tty_reset(STDIN_FILENO);
    
    return 0;
}
