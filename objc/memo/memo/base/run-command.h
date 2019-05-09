//
//  run-command.h
//  memo
//
//  Created by 赵睿 on 5/7/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#ifndef run_command_h
#define run_command_h

#include "argv-array.h"
#include "memo-compat-util.h"

struct child_process {
    const char **argv;
    struct argv_array args;
    struct argv_array env_array;
    pid_t pid;
    
    int trace2_child_id;
    uint64_t trace2_child_us_start;
    const char *trace2_child_class;
    const char *trace2_hook_name;
    
    /*
     * Using .in, .out, .err:
     * - Specify 0 for no redirections (child inherits stdin, stdout,
     *   stderr from parent).
     * - Specify -1 to have a pipe allocated as follows:
     *     .in: returns the writable pipe end; parent writes to it,
     *          the readable pipe end becomes child's stdin
     *     .out, .err: returns the readable pipe end; parent reads from
     *          it, the writable pipe end becomes child's stdout/stderr
     *   The caller of start_command() must close the returned FDs
     *   after it has completed reading from/writing to it!
     * - Specify > 0 to set a channel to a particular FD as follows:
     *     .in: a readable FD, becomes child's stdin
     *     .out: a writable FD, becomes child's stdout/stderr
     *     .err: a writable FD, becomes child's stderr
     *   The specified FD is closed by start_command(), even in case
     *   of errors!
     */
    int in;
    int out;
    int err;
    const char *dir;
    const char *const *env;
    unsigned no_stdin:1;
    unsigned no_stdout:1;
    unsigned no_stderr:1;
    unsigned git_cmd:1; /* if this is to be git sub-command */
    unsigned silent_exec_failure:1;
    unsigned stdout_to_stderr:1;
    unsigned use_shell:1;
    unsigned clean_on_exit:1;
    unsigned wait_after_clean:1;
    void (*clean_on_exit_handler)(struct child_process *process);
    void *clean_on_exit_handler_cbdata;
};

#endif /* run_command_h */
