//
//  Result.m
//  lsapp
//
//  Created by 赵睿 on 3/10/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import "Result.h"

@implementation Result

-(instancetype)init {
    if (self = [super init]) {
        _resultMap = [NSMutableDictionary new];
    }
    return self;
}

-(void)queryDidFinishGathering:(NSNotification*)n {
    NSMetadataQuery* q = n.object;
    for (NSMetadataItem* item in q.results) {
        NSString* appName = [item valueForAttribute:(__bridge NSString*)kMDItemDisplayName];
        NSString* appPath = [item valueForAttribute:(__bridge NSString*)kMDItemPath];
        self.resultMap[appName] = appPath;
#if DEBUG
        printf("%s %s\n", [appName UTF8String], [appPath UTF8String]);
#endif
    }
    [q stopQuery];
    CFRunLoopStop(CFRunLoopGetCurrent());
}

@end
