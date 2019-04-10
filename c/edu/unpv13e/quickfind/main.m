//
//  main.m
//  quickfind
//
//  Created by 赵睿 on 4/10/19.
//  Copyright © 2019 com.alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
//#include "unp.h"
/* If anything changes in the following list of #includes, must change
 acsite.m4 also, for configure's tests. */

#include    <sys/types.h>    /* basic system data types */
#include    <sys/socket.h>    /* basic socket definitions */
#include    <sys/time.h>    /* timeval{} for select() */
#include    <time.h>        /* timespec{} for pselect() */
#include    <netinet/in.h>    /* sockaddr_in{} and other Internet defns */
#include    <arpa/inet.h>    /* inet(3) functions */
#include    <errno.h>
#include    <fcntl.h>        /* for nonblocking */
#include    <netdb.h>
#include    <signal.h>
#include    <stdio.h>
#include    <stdlib.h>
#include    <string.h>
#include    <sys/stat.h>    /* for S_xxx file mode constants */
#include    <sys/uio.h>        /* for iovec{} and readv/writev */
#include    <unistd.h>
#include    <sys/wait.h>
#include    <sys/un.h>        /* for Unix domain sockets */

#ifdef    HAVE_SYS_SELECT_H
# include    <sys/select.h>    /* for convenience */
#endif

#ifdef    HAVE_SYS_SYSCTL_H
# include    <sys/sysctl.h>
#endif

#ifdef    HAVE_POLL_H
# include    <poll.h>        /* for convenience */
#endif

#ifdef    HAVE_STRINGS_H
# include    <strings.h>        /* for convenience */
#endif

/* Three headers are normally needed for socket/file ioctl's:
 * <sys/ioctl.h>, <sys/filio.h>, and <sys/sockio.h>.
 */
#ifdef    HAVE_SYS_IOCTL_H
# include    <sys/ioctl.h>
#endif
#ifdef    HAVE_SYS_FILIO_H
# include    <sys/filio.h>
#endif
#ifdef    HAVE_SYS_SOCKIO_H
# include    <sys/sockio.h>
#endif

#ifdef    HAVE_PTHREAD_H
# include    <pthread.h>
#endif

#ifdef HAVE_NET_IF_DL_H
# include    <net/if_dl.h>
#endif

#include    <netinet/tcp.h>        /* for TCP_MAXSEG */


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // copy keywords here to quickly find out where is it define
        TCP_MAXSEG
        TCP_NODELAY
        
    }
    return 0;
}
