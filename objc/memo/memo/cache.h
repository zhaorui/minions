//
//  cache.h
//  memo
//
//  Created by 赵睿 on 3/25/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#ifndef cache_h
#define cache_h

#include "memo-compat-util.h"
#include "apue.h"

#define alloc_nr(x) (((x)+16)*3/2)

/*
 * Realloc the buffer pointed at by variable 'x' so that it can hold
 * at least 'nr' entries; the number of entries currently allocated
 * is 'alloc', using the standard growing factor alloc_nr() macro.
 *
 * DO NOT USE any expression with side-effect for 'x', 'nr', or 'alloc'.
 */
#define ALLOC_GROW(x, nr, alloc) \
do { \
    if ((nr) > alloc) { \
        if (alloc_nr(alloc) < (nr)) \
            alloc = (nr); \
        else \
            alloc = alloc_nr(alloc); \
    REALLOC_ARRAY(x, alloc); \
} \
} while (0)

#endif /* cache_h */
