//
//  color.h
//  memo
//
//  Created by 赵睿 on 4/7/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#ifndef color_h
#define color_h

/*
 * The maximum length of ANSI color sequence we would generate:
 * - leading ESC '['            2
 * - attr + ';'                 2 * num_attr (e.g. "1;")
 * - no-attr + ';'              3 * num_attr (e.g. "22;")
 * - fg color + ';'             17 (e.g. "38;2;255;255;255;")
 * - bg color + ';'             17 (e.g. "48;2;255;255;255;")
 * - terminating 'm' NUL        2
 *
 * The above overcounts by one semicolon but it is close enough.
 *
 * The space for attributes is also slightly overallocated, as
 * the negation for some attributes is the same (e.g., nobold and nodim).
 *
 * We allocate space for 7 attributes.
 */
#define COLOR_MAXLEN 75

#define GIT_COLOR_NORMAL    ""
#define GIT_COLOR_RESET        "\033[m"
#define GIT_COLOR_BOLD        "\033[1m"
#define GIT_COLOR_RED        "\033[31m"
#define GIT_COLOR_GREEN        "\033[32m"
#define GIT_COLOR_YELLOW    "\033[33m"
#define GIT_COLOR_BLUE        "\033[34m"
#define GIT_COLOR_MAGENTA    "\033[35m"
#define GIT_COLOR_CYAN        "\033[36m"
#define GIT_COLOR_BOLD_RED    "\033[1;31m"
#define GIT_COLOR_BOLD_GREEN    "\033[1;32m"
#define GIT_COLOR_BOLD_YELLOW    "\033[1;33m"
#define GIT_COLOR_BOLD_BLUE    "\033[1;34m"
#define GIT_COLOR_BOLD_MAGENTA    "\033[1;35m"
#define GIT_COLOR_BOLD_CYAN    "\033[1;36m"
#define GIT_COLOR_FAINT_RED    "\033[2;31m"
#define GIT_COLOR_FAINT_GREEN    "\033[2;32m"
#define GIT_COLOR_FAINT_YELLOW    "\033[2;33m"
#define GIT_COLOR_FAINT_BLUE    "\033[2;34m"
#define GIT_COLOR_FAINT_MAGENTA    "\033[2;35m"
#define GIT_COLOR_FAINT_CYAN    "\033[2;36m"
#define GIT_COLOR_BG_RED    "\033[41m"
#define GIT_COLOR_BG_GREEN    "\033[42m"
#define GIT_COLOR_BG_YELLOW    "\033[43m"
#define GIT_COLOR_BG_BLUE    "\033[44m"
#define GIT_COLOR_BG_MAGENTA    "\033[45m"
#define GIT_COLOR_BG_CYAN    "\033[46m"
#define GIT_COLOR_FAINT        "\033[2m"
#define GIT_COLOR_FAINT_ITALIC    "\033[2;3m"
#define GIT_COLOR_REVERSE    "\033[7m"

/* A special value meaning "no color selected" */
#define GIT_COLOR_NIL "NIL"

/*
 * Output the formatted string in the specified color (and then reset to normal
 * color so subsequent output is uncolored). Omits the color encapsulation if
 * `color` is NULL. The `color_fprintf_ln` prints a new line after resetting
 * the color.  The `color_print_strbuf` prints the contents of the given
 * strbuf (BUG: but only up to its first NUL character).
 */
__attribute__((format (printf, 3, 4)))
int color_fprintf(FILE *fp, const char *color, const char *fmt, ...);
__attribute__((format (printf, 3, 4)))
int color_fprintf_ln(FILE *fp, const char *color, const char *fmt, ...);

#endif /* color_h */
