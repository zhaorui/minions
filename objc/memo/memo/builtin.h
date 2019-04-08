//
//  builtin.h
//  memo
//
//  Created by 赵睿 on 3/24/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#ifndef builtin_h
#define builtin_h

#include "memo-compat-util.h"

extern int is_builtin(const char *s);

extern int cmd_add(int argc, const char **argv, const char *prefix);
extern int cmd_help(int argc, const char **argv, const char *prefix);
extern int cmd_find(int argc, const char **argv, const char *prefix);
extern int cmd_home(int argc, const char **argv, const char *prefix);

#endif /* builtin_h */
