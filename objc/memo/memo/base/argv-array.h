//
//  argv-array.h
//  memo
//
//  Created by 赵睿 on 3/25/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#ifndef argv_array_h
#define argv_array_h

extern const char *empty_argv[];

struct argv_array {
    const char **argv;
    int argc;
    int alloc;
};

#define ARGV_ARRAY_INIT { empty_argv, 0, 0 }

void argv_array_init(struct argv_array *);
const char *argv_array_push(struct argv_array *, const char *);
void argv_array_clear(struct argv_array *);

#endif /* argv_array_h */
