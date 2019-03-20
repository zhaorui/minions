//
//  MemoConfig.m
//  memo
//
//  Created by 赵睿 on 3/20/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import "MemoConfig.h"

@implementation MemoConfig

+ (id)sharedConfig {
    static dispatch_once_t onceToken;
    static MemoConfig* _memo_config;
    dispatch_once(&onceToken, ^{
        [NSKeyedUnarchiver unarchiveObjectWithFile:];
    });
    return _memo_config;
}

- (NSString*)path {
    BOOL isFolder = NO;
    NSString* configDir = [NSHomeDirectory() stringByAppendingPathComponent:@"config/memo"];
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:configDir isDirectory:&isFolder];
    if (!isExist || !isFolder) {
        [[NSFileManager defaultManager] createDirectoryAtPath:<#(nonnull NSString *)#> withIntermediateDirectories:<#(BOOL)#> attributes:<#(nullable NSDictionary<NSFileAttributeKey,id> *)#> error:<#(NSError * _Nullable __autoreleasing * _Nullable)#>]
    }
    
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - NSCoding
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.root = [aDecoder decodeObjectForKey:@"root"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.root forKey:@"root"];
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - NSSecureCoding
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
