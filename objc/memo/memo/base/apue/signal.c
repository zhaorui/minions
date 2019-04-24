//
//  prmask.c
//  memo
//
//  Created by 赵睿 on 4/23/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#include "apue.h"

void pr_mask(const char *str);

static sigset_t omask;

static void sig_handler(int signo) {
    char description[1024];
    snprintf(description, sizeof(description), "capture signal %d, and mask is ", signo);
    pr_mask(description);
}

void
pr_mask(const char *str)
{
    sigset_t    sigset;
    int         errno_save;
    
    errno_save = errno;        /* we can be called by signal handlers */
    if (sigprocmask(0, NULL, &sigset) < 0) {
        err_ret("sigprocmask error");
    } else {
        printf("%s", str);
        if (sigismember(&sigset, SIGHUP))
            printf(" SIGHUP");
        if (sigismember(&sigset, SIGINT))
            printf(" SIGINT");
        if (sigismember(&sigset, SIGQUIT))
            printf(" SIGQUIT");
        if (sigismember(&sigset, SIGILL))
            printf(" SIGILL");
        if (sigismember(&sigset, SIGTRAP))
            printf(" SIGTRAP");
        if (sigismember(&sigset, SIGABRT))
            printf(" SIGABRT");
        if (sigismember(&sigset, SIGEMT))
            printf(" SIGEMT");
        if (sigismember(&sigset, SIGFPE))
            printf(" SIGFPE");
        if (sigismember(&sigset, SIGKILL))
            printf(" SIGKILL");
        if (sigismember(&sigset, SIGBUS))
            printf(" SIGBUS");
        if (sigismember(&sigset, SIGSEGV))
            printf(" SIGSEV");
        if (sigismember(&sigset, SIGSYS))
            printf(" SIGSYS");
        if (sigismember(&sigset, SIGPIPE))
            printf(" SIGPIPE");
        if (sigismember(&sigset, SIGTERM))
            printf(" SIGTERM");
        if (sigismember(&sigset, SIGURG))
            printf(" SIGURG");
        if (sigismember(&sigset, SIGSTOP))
            printf(" SIGSTOP");
        if (sigismember(&sigset, SIGTSTP))
            printf(" SIGTSTP");
        if (sigismember(&sigset, SIGCONT))
            printf(" SIGCONT");
        if (sigismember(&sigset, SIGCHLD))
            printf(" SIGCHLD");
        if (sigismember(&sigset, SIGTTIN))
            printf(" SIGTTIN");
        if (sigismember(&sigset, SIGTTOU))
            printf(" SIGTTOU");
        if (sigismember(&sigset, SIGIO))
            printf(" SIGIO");
        if (sigismember(&sigset, SIGXCPU))
            printf(" SIGXCPU");
        if (sigismember(&sigset, SIGXFSZ))
            printf(" SIGXFSZ");
        if (sigismember(&sigset, SIGVTALRM))
            printf(" SIGVTALRM");
        if (sigismember(&sigset, SIGPROF))
            printf(" SIGPROF");
        if (sigismember(&sigset, SIGWINCH))
            printf(" SIGWINCH");
        if (sigismember(&sigset, SIGINFO))
            printf(" SIGINFO");
        if (sigismember(&sigset, SIGUSR1))
            printf(" SIGUSR1");
        if (sigismember(&sigset, SIGUSR1))
            printf(" SIGUSR2");
        
        printf("\n");
    }
    
    errno = errno_save;        /* restore errno */
}

int
capture_sig(int sig) {
    
    struct sigaction saIgnore, saOrig;
    
    // playaround with these parameters to understand how sigaction work
    sigset_t ignore_handler_mask;
    sigemptyset(&ignore_handler_mask);
    sigaddset(&ignore_handler_mask, SIGUSR1);
    sigaddset(&ignore_handler_mask, SIGUSR2);
    
    saIgnore.sa_handler = sig_handler;
    saIgnore.sa_flags = SA_NODEFER;
    saIgnore.sa_mask = ignore_handler_mask;
    
    return sigaction(sig, &saIgnore, &saOrig);
}

int block_sig(int sig) {
    sigset_t mask;
    sigemptyset(&mask);
    sigaddset(&mask, sig);
    return sigprocmask(SIG_BLOCK, &mask, &omask);
}

int unblock_sig(int sig) {
    sigset_t mask;
    sigemptyset(&mask);
    sigaddset(&mask, sig);
    return sigprocmask(SIG_UNBLOCK, &mask, &omask);
}

