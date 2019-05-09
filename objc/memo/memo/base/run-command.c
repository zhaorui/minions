//
//  run-command.c
//  memo
//
//  Created by 赵睿 on 5/7/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#include "run-command.h"

void child_process_init(struct child_process *child)
{
    memset(child, 0, sizeof(*child));
    argv_array_init(&child->args);
    argv_array_init(&child->env_array);
}

void child_process_clear(struct child_process *child)
{
    argv_array_clear(&child->args);
    argv_array_clear(&child->env_array);
}

struct child_to_clean {
    pid_t pid;
    struct child_process *process;
    struct child_to_clean *next;
};
static struct child_to_clean *children_to_clean;
static int installed_child_cleanup_handler;

static void cleanup_children(int sig, int in_signal)
{
    struct child_to_clean *children_to_wait_for = NULL;
    
    while (children_to_clean) {
        struct child_to_clean *p = children_to_clean;
        children_to_clean = p->next;
        
        if (p->process && !in_signal) {
            struct child_process *process = p->process;
            if (process->clean_on_exit_handler) {
                trace_printf(
                             "trace: run_command: running exit handler for pid %"
                             PRIuMAX, (uintmax_t)p->pid
                             );
                process->clean_on_exit_handler(process);
            }
        }
        
        kill(p->pid, sig);
        
        if (p->process && p->process->wait_after_clean) {
            p->next = children_to_wait_for;
            children_to_wait_for = p;
        } else {
            if (!in_signal)
                free(p);
        }
    }
    
    while (children_to_wait_for) {
        struct child_to_clean *p = children_to_wait_for;
        children_to_wait_for = p->next;
        
        while (waitpid(p->pid, NULL, 0) < 0 && errno == EINTR)
            ; /* spin waiting for process exit or error */
        
        if (!in_signal)
            free(p);
    }
}
