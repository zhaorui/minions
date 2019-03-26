//
//  Utility.h
//  XMacroDemo
//
//  Created by 赵睿 on 3/12/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#ifndef Utility_h
#define Utility_h

// A way to define printf with \n at the end
#define __DBG_INT(fmt, ...) printf(fmt "%s", __VA_ARGS__);
#define DBG(...) __DBG_INT(__VA_ARGS__, "\n")

// Another way to define printf with \n at the end
#define _PRN(fmt, ...)  printf(fmt, ##__VA_ARGS__)
#define PRN(fmt, ...)  _PRN(fmt"\n", ##__VA_ARGS__)


#endif /* Utility_h */
