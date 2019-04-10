//
//  NSURL+Convience.m
//  memo
//
//  Created by 赵睿 on 4/9/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import "NSURL+Convience.h"

@implementation NSURL (Convience)

- (BOOL)isFolder {
    NSNumber *isDirectory;
    
    // this method allows us to get more information about an URL.
    // We're passing NSURLIsDirectoryKey as key because that's the info we want to know.
    // Also, we pass a reference to isDirectory variable, so it can be modified to have the return value
    BOOL success = [self getResourceValue:&isDirectory
                                   forKey:NSURLIsDirectoryKey
                                    error:nil];
    
    return success && [isDirectory boolValue];
    
}

@end
