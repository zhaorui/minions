//
//  common.h
//  memo
//
//  Created by 赵睿 on 4/5/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#ifndef common_h
#define common_h

#include <termios.h>
#include "string-list.h"
#include "memo-compat-util.h"

/// Save the shell mode on startup so we can restore them on exit.
extern struct termios shell_modes;

void show_tty_info(void);

#endif /* common_h */
