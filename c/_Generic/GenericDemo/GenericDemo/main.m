//
//  main.m
//  GenericDemo
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//
// _Generic Demo is from below sites
// http://www.cnblogs.com/zenny-chen/archive/2012/09/20/2695381.html
// https://www.cnblogs.com/zenny-chen/p/3303560.html

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/*
 C11中的泛型机制由关键字_Generic引出，其语法形式为：
 
 _Generic ( assignment-expression , generic-assoc-list )
 
 generic-assoc-list:
 
 generic-association
 
 generic-assoc-list , generic-association
 
 generic-association:
 type-name : assignment-expression
 
 default : assignment-expression
 */

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - _Generic
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#define GENERAL_ABS(x)  _Generic((x), int:abs, float:fabsf, double:fabs)(x)

static void GenericTest(void)
{
    printf("int abs: %d\n", GENERAL_ABS(-12));
    printf("float abs: %f\n", GENERAL_ABS(-12.04f));
    printf("double abs: %f\n", GENERAL_ABS(-13.09876));
    
    int a = 10;
    int b = 0, c = 0;
    
    _Generic(a + 0.1f, int:b, float:c, default:b)++;
    printf("b = %d, c = %d\n", b, c);
    
    // _Generic里的assigment-expressiong,只获取其类型而不会对它做运行时计算, 所以a值不变。
    _Generic(a += 1.1f, int:b, float:c, default:b)++;
    printf("a = %d, b = %d, c = %d\n", a, b, c);
}

struct MyStruct { int a, b; } s;
static void GenericTestII(void) {
    
    /*generic-association-list中必须要有与assignment-expression
     类型相同的generic-association，否则编译会报错*/
    
    //_Generic("Hello", const char*:puts("OK!"));    // ERROR! "Hello"为char[6]类型
    _Generic("Hello", char*:puts("OK!"));    // OK
    _Generic((const char*)"Hello", const char*:puts("OK!"));    // OK
    //_Generic(s, int:puts("OK!"));    // ERROR
    _Generic(s, struct MyStruct:puts("OK!"));    // OK
    _Generic(s, int:puts("Yep!"), default:puts("Others"));    // OK
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  pragma mark - compiler builtin functions
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

// type __builtin_choose_expr (const_exp, exp1, exp2)
void builtin_choose_expr_test(void) {
    
    /*如果const_expr的结果非0，那么生成exp1, 返回exp1的值， 反之亦然*/
    (void)__builtin_choose_expr(100 < 1000, puts("OK"), puts("NG"));
    int a = __builtin_choose_expr(sizeof('a') == 1, "YES", 100); //'a' is type int
    printf("The value is: %d\n", a);
}

// int __builtin_types_compatible_p (type1, type2)
void builtin_types_compatible_p_test(void) {
    int r = __builtin_types_compatible_p(typeof('a'), char);
    printf("result 1 is: %d\n", r);
    
    r = __builtin_types_compatible_p(typeof('a'), const int);
    printf("result 2 is: %d\n", r);
}

void GenericEquivalentTest(void) {
    _Generic('a', int:puts("WOW"), char:puts("Ja~~"), default:puts("Oui~~"));
    
    // equivalent
    (void)__builtin_choose_expr(__builtin_types_compatible_p(typeof('a'), int), puts("WOW"),
                                __builtin_choose_expr(__builtin_types_compatible_p(typeof('a'), char), puts("Ja~~"), puts("Oui~~")));
}

int main(int argc, const char * argv[]) {
    GenericTest();
    GenericTestII();
    builtin_choose_expr_test();
    builtin_types_compatible_p_test();
    
    return 0;
}
