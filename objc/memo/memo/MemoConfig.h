//
//  MemoConfig.h
//  memo
//
//  Created by 赵睿 on 3/20/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MemoConfig : NSObject <NSSecureCoding>

@property (copy, nonatomic) NSString* location; // memo location
@property (readonly, nonatomic) NSString* path; // memo config path

+ (id)sharedConfig;

# pragma mark - json
+ (_Nullable instancetype)fromJSON:(NSString *)json encoding:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
+ (_Nullable instancetype)fromData:(NSData *)data error:(NSError *_Nullable *)error;
- (NSString *_Nullable)toJSON:(NSStringEncoding)encoding error:(NSError *_Nullable *)error;
- (NSData *_Nullable)toData:(NSError *_Nullable *)error;

@end

NS_ASSUME_NONNULL_END
