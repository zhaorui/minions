//
//  main.m
//  XMacroDemo
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//
// Definition of X-macro can be found at https://en.wikipedia.org/wiki/X_Macro
// I am trying to implement an enum type and we can easily get the name of each item of it

#import <Foundation/Foundation.h>
#import "Utility.h"

// Way No.1 - Use X macros, suggested!
#define X_NUMBERS \
X(ONE, 1001) \
X(TWO, 1002) \
X(THREE, 1003)

typedef NS_ENUM(NSUInteger, Number) {
#define X(EnumItem, val) Number##EnumItem=val,
    X_NUMBERS
#undef X
};

NSString* queryNumberName(Number n) {
    switch (n) {
#define X(EnumItem, val) case Number##EnumItem: return @#EnumItem;
            X_NUMBERS
#undef X
        default: return nil;
    }
}

// Way No. 2 - Use gcc array initialize technique, waste memory!!
typedef enum : NSUInteger {
    enum1 = 10001,
    enum2,
} SimpleEnum;

const char * enum_to_string_map[]={
    [enum1]="string1",
    [enum2]="string2"
};


#define FOO(...)       printf(__VA_ARGS__)
#define BAR(fmt, ...)  printf(fmt, ##__VA_ARGS__)


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Number n = NumberONE;
        DBG("number is %ld, its name is %s", n, [queryNumberName(n) UTF8String]);
        DBG("enum1 is %ld, its name is %s", enum1, enum_to_string_map[enum1]);
        DBG("cool");
        
        PRN("number is %ld, its name is %s", n, [queryNumberName(n) UTF8String]);
        PRN("enum1 is %ld, its name is %s", enum1, enum_to_string_map[enum1]);
        PRN("cool");
    }
    return 0;
}
