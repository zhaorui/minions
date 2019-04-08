//
//  memo.c
//  memo
//
//  Created by 赵睿 on 3/24/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#include "builtin.h"
#include "argv-array.h"
#include "string-list.h"

#define RESERVED    (1<<0)
#define USE_PAGER        (1<<2)

struct cmd_struct {
    const char *cmd;
    int (*fn)(int, const char **, const char *);
    unsigned int option;
};

const char memo_usage_string[] =
   "memo [--version] [--help] <command> [<args>]";

const char memo_more_info_string[] =
"See 'memo help <command>' or 'memo help <concept>'\n"
"to read about a specific subcommand or concept.";

static int use_pager = -1;

static struct cmd_struct commands[] = {
    { "add", cmd_add, RESERVED },
    { "find", cmd_find, RESERVED},
    { "help", cmd_help, RESERVED},
    { "home", cmd_home, RESERVED},
};

static struct cmd_struct *get_builtin(const char *s)
{
    int i;
    for (i = 0; i < ARRAY_SIZE(commands); i++) {
        struct cmd_struct *p = commands + i;
        if (!strcmp(s, p->cmd))
            return p;
    }
    return NULL;
}

int is_builtin(const char *s)
{
    return !!get_builtin(s);
}

static int run_builtin(struct cmd_struct *p, int argc, const char **argv)
{
    int status, help;
    struct stat st;
    const char *prefix;
    
    prefix = NULL;
    help = argc == 2 && !strcmp(argv[1], "-h");
    
    status = p->fn(argc, argv, prefix);
    
    if (status)
        return status;
    
    /* Somebody closed stdout? */
    if (fstat(fileno(stdout), &st))
        return 0;
    /* Ignore write errors for pipes and sockets.. */
    if (S_ISFIFO(st.st_mode) || S_ISSOCK(st.st_mode))
        return 0;
    
    /* Check for ENOSPC and EIO errors.. */
    if (fflush(stdout))
        die_errno("write failure on standard output");
    if (ferror(stdout))
        die("unknown write failure on standard output");
    if (fclose(stdout))
        die_errno("close failed on standard output");
    return 0;
}

static void handle_builtin(int argc, const char **argv)
{
    struct argv_array args = ARGV_ARRAY_INIT;
    const char *cmd;
    struct cmd_struct *builtin;
    
    cmd = argv[0];
    
    /* Turn "memo cmd --help" into "memo help cmd" */
    if (argc > 1 && !strcmp(argv[1], "--help")) {
        int i;
        
        argv[1] = argv[0];
        argv[0] = cmd = "help";
        
        for (i = 0; i < argc; i++) {
            argv_array_push(&args, argv[i]);
            if (!i)
                argv_array_push(&args, "--exclude-guides");
        }
        
        argc++;
        argv = args.argv;
    }
    
    builtin = get_builtin(cmd);
    if (builtin)
        exit(run_builtin(builtin, argc, argv));
    argv_array_clear(&args);
}

static int handle_options(const char ***argv, int *argc, int *envchanged)
{
    const char **orig_argv = *argv;
    
    while (*argc > 0) {
        const char *cmd = (*argv)[0];
        if (cmd[0] != '-')
            break;
        
        /*
         * For legacy reasons, the "version" and "help"
         * commands can be written with "--" prepended
         * to make them look like flags.
         */
        if (!strcmp(cmd, "--help") || !strcmp(cmd, "--version"))
            break;
        
        /*
         * Check remaining flags.
         */
        
        if (!strcmp(cmd, "-p") || !strcmp(cmd, "--paginate")) {
            use_pager = 1;
        } else if (!strcmp(cmd, "-P") || !strcmp(cmd, "--no-pager")) {
            use_pager = 0;
        } else {
            fprintf(stderr, "unknown option: %s\n", cmd);
            usage(memo_usage_string);
        }
        
        (*argv)++;
        (*argc)--;
    }
    return (int)((*argv) - orig_argv);
}

static int run_argv(int *argcp, const char ***argv)
{

    
    handle_builtin(*argcp, *argv);
    
    // we could handle alias in here
    
    return 0;
}

int cmd_main(int argc, const char **argv)
{
    const char *cmd;
    int done_help = 0;
    
    cmd = argv[0];
    if (!cmd)
        cmd = "memo-help";
    else {
        const char *slash = find_last_dir_sep(cmd);
        if (slash)
            cmd = slash + 1;
    }
    
    /*
     * "memo-xxxx" is the same as "memo xxxx", but we obviously:
     *
     *  - cannot take flags in between the "memo" and the "xxxx".
     *  - cannot execute it externally (since it would just do
     *    the same thing over again)
     *
     * So we just directly call the builtin handler, and die if
     * that one cannot handle it.
     */
    if (skip_prefix(cmd, "memo-", &cmd)) {
        argv[0] = cmd;
        handle_builtin(argc, argv);
        die("cannot handle %s as a builtin", cmd);
    }
    
    /* Look for flags.. */
    argv++;
    argc--;
    handle_options(&argv, &argc, NULL);
    if (argc > 0) {
        /* translate --help and --version into commands */
        skip_prefix(argv[0], "--", &argv[0]);
    } else {
        /* The user didn't specify a command; give them help */
        printf("usage: %s\n\n", memo_usage_string);
        printf("\n%s\n", memo_more_info_string);
        exit(1);
    }
    cmd = argv[0];
    
    while (1) {
        run_argv(&argc, &argv);
        if (errno != ENOENT)
            break;
        if (!done_help) {
            // help unknown commnad here
            done_help = 1;
        } else
            break;
    }
    
    fprintf(stderr, "failed to run command '%s': %s\n",
            cmd, strerror(errno));
    
    return 1;
}

