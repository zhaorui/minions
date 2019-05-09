//
//  pthread-utils.h
//  memo
//
//  Created by 赵睿 on 5/7/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#ifndef pthread_utils_h
#define pthread_utils_h

#ifndef NO_PTHREADS
#include <pthread.h>

#define HAVE_THREADS 1

#else

#define HAVE_THREADS 0

#endif /* NO_PTHREADS */

#endif /* pthread_utils_h */
