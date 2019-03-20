//
//  UserProfile.h
//  FiltersSortingDemoTests
//
//  Created by 赵睿 on 3/10/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Gender) {
    GenderMale,
    GenderFemale,
};

NS_ASSUME_NONNULL_BEGIN

@interface UserProfile : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, copy) NSString *phoneNumber;

+ (instancetype)personWithName:(NSString *)name age:(NSUInteger)age gender:(Gender)gender phone:(NSString*)phoneNumber;

@end

NS_ASSUME_NONNULL_END
