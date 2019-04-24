//
//  apue.h
//  memo
//
//  Created by 赵睿 on 4/16/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#ifndef apue_h
#define apue_h

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

/* Miscellaneous constants */
#define    MAXLINE     4096    /* max text line length */
#define    BUFFSIZE    8192    /* buffer size for reads and writes */

// ttymodes.c
int tty_cbreak(int fd);    /* put terminal into a cbreak mode */
int tty_raw(int fd);        /* put terminal into a raw mode */
int tty_reset(int fd);        /* restore terminal's mode */
void tty_atexit(void);       /* can be set up by atexit(tty_atexit) */
struct termios * tty_termios(void);  /* let caller see original tty state */

// error.c
void err_quit(const char *fmt, ...);
void err_msg(const char *fmt, ...);
void err_dump(const char *fmt, ...);
void err_sys(const char *fmt, ...);
void err_ret(const char *fmt, ...);

// writen.c & readn.c
ssize_t Readn(int fd, void *ptr, size_t nbytes);
void Writen(int fd, void *ptr, size_t nbytes);

// signal.c
void pr_mask(const char *str);
int capture_sig(int sig);
int block_sig(int sig);
int unblock_sig(int sig);


// process.c
pid_t wait_process_id(pid_t pid, int op);

#endif /* apue_h */
