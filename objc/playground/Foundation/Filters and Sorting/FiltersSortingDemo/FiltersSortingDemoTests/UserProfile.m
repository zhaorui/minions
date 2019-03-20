//
//  UserProfile.m
//  FiltersSortingDemoTests
//
//  Created by 赵睿 on 3/10/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile

+ (instancetype)personWithName:(NSString *)name age:(NSUInteger)age gender:(Gender)gender phone:(NSString*)phoneNumber {
    UserProfile* profile = [UserProfile new];
    profile.name = name;
    profile.age = age;
    profile.gender = gender;
    profile.phoneNumber = phoneNumber;
    return profile;
}

@end
