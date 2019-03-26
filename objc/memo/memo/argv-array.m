//
//  argv-array.m
//  memo
//
//  Created by 赵睿 on 3/25/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//
#include "argv-array.h"
#include "cache.h"

const char *empty_argv[] = { NULL };

void argv_array_init(struct argv_array *array)
{
    array->argv = empty_argv;
    array->argc = 0;
    array->alloc = 0;
}

static void argv_array_push_nodup(struct argv_array *array, const char *value)
{
    if (array->argv == empty_argv)
        array->argv = NULL;
    
    ALLOC_GROW(array->argv, array->argc + 2, array->alloc);
    array->argv[array->argc++] = value;
    array->argv[array->argc] = NULL;
}

const char *argv_array_push(struct argv_array *array, const char *value)
{
    argv_array_push_nodup(array, xstrdup(value));
    return array->argv[array->argc - 1];
}

void argv_array_clear(struct argv_array *array)
{
    if (array->argv != empty_argv) {
        int i;
        for (i = 0; i < array->argc; i++)
            free((char *)array->argv[i]);
        free(array->argv);
    }
    argv_array_init(array);
}
