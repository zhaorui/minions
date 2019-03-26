//
//  string-list.c
//  memo
//
//  Created by 赵睿 on 3/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//
#include "cache.h"
#include "string-list.h"

void string_list_init(struct string_list *list, int strdup_strings)
{
    memset(list, 0, sizeof(*list));
    list->strdup_strings = strdup_strings;
}

struct string_list_item *unsorted_string_list_lookup(struct string_list *list,
                                                     const char *string)
{
    struct string_list_item *item;
    compare_strings_fn cmp = list->cmp ? list->cmp : strcmp;
    
    for_each_string_list_item(item, list)
    if (!cmp(string, item->string))
        return item;
    return NULL;
}
