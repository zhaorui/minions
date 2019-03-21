//
//  MemoConfig.m
//  memo
//
//  Created by 赵睿 on 3/20/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import "MemoConfig.h"

#define DEFAULT_LOCATION "~/Document/memo"
#define CONFIG_DIR  "~/.config/memo"
#define CONFIG_PATH CONFIG_DIR"/memoconfig"

@interface MemoConfig ()

@property (readwrite, copy) NSString* path;

@end

@implementation MemoConfig

+ (id)sharedConfig {
    static dispatch_once_t onceToken;
    static MemoConfig* _memo_config;
    dispatch_once(&onceToken, ^{
        
        // create memoconfig if it's not exist
        BOOL isF = NO;
        NSString* memoconfig = [@CONFIG_PATH stringByStandardizingPath];
        NSString* memoconfigDir = [@CONFIG_DIR stringByStandardizingPath];
        BOOL isE = [[NSFileManager defaultManager] fileExistsAtPath:memoconfig isDirectory:&isF];
        
        if (!isE || isF) {
            printf("setup your memo root dir ("DEFAULT_LOCATION"): ");
            
            char *line = NULL;
            size_t linecap = 0;
            ssize_t length = 0;
            _memo_config = [MemoConfig new];
            if ((length = getline(&line, &linecap, stdin)) < 0) {
                perror("getline fail");
                exit(1);
            }
            
            NSString* inputLine = [[NSString stringWithUTF8String:line]
                                   stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
            if ([inputLine length] == 0) {
                _memo_config.location = @DEFAULT_LOCATION;
            } else {
                _memo_config.location = inputLine;
            }
            
            NSKeyedArchiver* plistEncoder = [[NSKeyedArchiver alloc] initRequiringSecureCoding:YES];
            [plistEncoder encodeObject:_memo_config forKey:@"root"];
            
            isE = [[NSFileManager defaultManager] fileExistsAtPath:memoconfigDir isDirectory:&isF];
            if (!isE || !isF) {
                NSError* createFolderErr = nil;
                [[NSFileManager defaultManager] createDirectoryAtPath:memoconfigDir
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:&createFolderErr];
                if (createFolderErr) {
                    printf("create %s fail\n", [@CONFIG_DIR UTF8String]);
                    exit(1);
                }
            }
            
            BOOL success = [[NSFileManager defaultManager] createFileAtPath:memoconfig
                                                                   contents:plistEncoder.encodedData
                                                                 attributes:nil];
            if (!success) {
                printf("fail to create "CONFIG_PATH"!\n");
                exit(1);
            }
            
        } else {
            NSData* content = [NSData dataWithContentsOfFile:memoconfig];
            NSError* decodeError;
            NSKeyedUnarchiver* decoder = [[NSKeyedUnarchiver alloc] initForReadingFromData:content
                                                                                     error:&decodeError];
            _memo_config = [[MemoConfig alloc] initWithCoder:decoder];
        }
        
        _memo_config.path = memoconfig;
    });
    return _memo_config;
}

- (NSString*)path {
    return self.path?:@CONFIG_PATH;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - NSCoding
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.location = [aDecoder decodeObjectForKey:@"root"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.location forKey:@"root"];
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - NSSecureCoding
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
