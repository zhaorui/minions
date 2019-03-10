//
//  main.m
//  lsapp
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Result.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Result* result = [[Result alloc] init];
        NSMetadataQuery* query = [[NSMetadataQuery alloc] init];
        [query setSearchScopes: [NSArray arrayWithObjects:@"/Applications",
                                                          @"/Library",
                                                          NSMetadataQueryUserHomeScope,
                                                          nil]];
        [query setPredicate:[NSPredicate predicateWithFormat:@"(kMDItemKind == 'Application') || \
                                                               (kMDItemKind == '应用程序') || \
                                                               (kMDItemContentType == 'com.apple.application-bundle')"]];
        [[NSNotificationCenter defaultCenter] addObserver:result
                                                 selector:@selector(queryDidFinishGathering:)
                                                     name:NSMetadataQueryDidFinishGatheringNotification
                                                   object:query];
        [query startQuery];
        
        CFRunLoopRun();
    }
    return 0;
}
