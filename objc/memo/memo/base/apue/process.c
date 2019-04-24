//
//  process.c
//  memo
//
//  Created by 赵睿 on 4/24/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#include "apue.h"

pid_t wait_process_id(pid_t pid, int op) {
    int status;
    char* options[3] = {"NULL"," WNOHANG", "WUNTRACED"};
    printf("waitpid %d with options %s\n", pid, options[op]);
    pid_t rpid = waitpid(pid, &status, op);
    printf("process %d report with errno %d:\n", rpid, errno);
    if (WIFEXITED(status)) {
        printf("process exit normally with status %d\n", WEXITSTATUS(status));
    } else if (WIFSIGNALED(status)) {
        printf("process exit by signal %d\n", WTERMSIG(status));
        printf("core dump [%c]\n", WCOREDUMP(status)?'Y':'N');
    } else if (WIFSTOPPED(status)) {
        printf("process is stopped by signal %d\n", WSTOPSIG(status));
    } else if (WIFCONTINUED(status)) {
        printf("process is continued\n");
    }
    return rpid;
}
