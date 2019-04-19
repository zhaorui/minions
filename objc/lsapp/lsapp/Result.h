//
//  Result.h
//  lsapp
//
//  Created by 赵睿 on 3/10/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Result : NSObject

@property(strong, nonatomic) NSMutableDictionary* resultMap;
-(void)queryDidFinishGathering:(NSNotification*)n; 

@end

NS_ASSUME_NONNULL_END
