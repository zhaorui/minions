//
//  wrapper.m
//  memo
//
//  Created by 赵睿 on 3/25/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "memo-compat-util.h"


static void do_nothing(size_t size)
{
}

static void (*try_to_free_routine)(size_t size) = do_nothing;

static int memory_limit_check(size_t size, int gentle)
{
    static size_t limit = SIZE_MAX;
    if (size > limit) {
        if (gentle) {
            error("attempting to allocate %"PRIuMAX" over limit %"PRIuMAX,
                  (uintmax_t)size, (uintmax_t)limit);
            return -1;
        } else
            die("attempting to allocate %"PRIuMAX" over limit %"PRIuMAX,
                (uintmax_t)size, (uintmax_t)limit);
    }
    return 0;
}

char *xstrdup(const char *str)
{
    char *ret = strdup(str);
    if (!ret) {
        try_to_free_routine(strlen(str) + 1);
        ret = strdup(str);
        if (!ret)
            die("Out of memory, strdup failed");
    }
    return ret;
}

static void *do_xmalloc(size_t size, int gentle)
{
    void *ret;
    
    if (memory_limit_check(size, gentle))
        return NULL;
    ret = malloc(size);
    if (!ret && !size)
        ret = malloc(1);
    if (!ret) {
        try_to_free_routine(size);
        ret = malloc(size);
        if (!ret && !size)
            ret = malloc(1);
        if (!ret) {
            if (!gentle)
                die("Out of memory, malloc failed (tried to allocate %lu bytes)",
                    (unsigned long)size);
            else {
                error("Out of memory, malloc failed (tried to allocate %lu bytes)",
                      (unsigned long)size);
                return NULL;
            }
        }
    }
#ifdef XMALLOC_POISON
    memset(ret, 0xA5, size);
#endif
    return ret;
}

void *xmalloc(size_t size)
{
    return do_xmalloc(size, 0);
}

void *xrealloc(void *ptr, size_t size)
{
    void *ret;
    
    memory_limit_check(size, 0);
    ret = realloc(ptr, size);
    if (!ret && !size)
        ret = realloc(ptr, 1);
    if (!ret) {
        try_to_free_routine(size);
        ret = realloc(ptr, size);
        if (!ret && !size)
            ret = realloc(ptr, 1);
        if (!ret)
            die("Out of memory, realloc failed");
    }
    return ret;
}

void *xcalloc(size_t nmemb, size_t size)
{
    void *ret;
    
    if (unsigned_mult_overflows(nmemb, size))
        die("data too large to fit into virtual memory space");
    
    memory_limit_check(size * nmemb, 0);
    ret = calloc(nmemb, size);
    if (!ret && (!nmemb || !size))
        ret = calloc(1, 1);
    if (!ret) {
        try_to_free_routine(nmemb * size);
        ret = calloc(nmemb, size);
        if (!ret && (!nmemb || !size))
            ret = calloc(1, 1);
        if (!ret)
            die("Out of memory, calloc failed");
    }
    return ret;
}
