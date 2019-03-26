//
//  memo-compat-util.h
//  memo
//
//  Created by 赵睿 on 3/24/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#ifndef memo_compat_util_h
#define memo_compat_util_h

#include <unistd.h>
#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stddef.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <errno.h>
#include <limits.h>
#include <sys/types.h>
#include <dirent.h>
#include <sys/time.h>
#include <time.h>
#include <signal.h>
#include <assert.h>
#include <regex.h>
#include <utime.h>
#include <syslog.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <pwd.h>
#include <sys/un.h>
#include <inttypes.h>


extern const char memo_usage_string[];
extern const char memo_more_info_string[];

/* Derived from Linux "Features Test Macro" header
 * Convenience macros to test the versions of gcc (or
 * a compatible compiler).
 * Use them like this:
 *  #if MEMO_GNUC_PREREQ (2,8)
 *   ... code requiring gcc 2.8 or later ...
 *  #endif
 */
#if defined(__GNUC__) && defined(__GNUC_MINOR__)
# define MEMO_GNUC_PREREQ(maj, min) \
((__GNUC__ << 16) + __GNUC_MINOR__ >= ((maj) << 16) + (min))
#else
#define MEMO_GNUC_PREREQ(maj, min) 0
#endif


/*
 * BUILD_ASSERT_OR_ZERO - assert a build-time dependency, as an expression.
 * @cond: the compile-time condition which must be true.
 *
 * Your compile will fail if the condition isn't true, or can't be evaluated
 * by the compiler.  This can be used in an expression: its value is "0".
 *
 * Example:
 *    #define foo_to_char(foo)                    \
 *         ((char *)(foo)                        \
 *          + BUILD_ASSERT_OR_ZERO(offsetof(struct foo, string) == 0))
 */
#define BUILD_ASSERT_OR_ZERO(cond) \
(sizeof(char [1 - 2*!(cond)]) - 1)

#if MEMO_GNUC_PREREQ(3, 1)
/* &arr[0] degrades to a pointer: a different type from an array */
# define BARF_UNLESS_AN_ARRAY(arr)                        \
BUILD_ASSERT_OR_ZERO(!__builtin_types_compatible_p(__typeof__(arr), \
__typeof__(&(arr)[0])))
#else
# define BARF_UNLESS_AN_ARRAY(arr) 0
#endif
/*
 * ARRAY_SIZE - get the number of elements in a visible array
 *  <at> x: the array whose size you want.
 *
 * This does not work on pointers, or arrays declared as [], or
 * function parameters.  With correct compiler support, such usage
 * will cause a build error (see the build_assert_or_zero macro).
 */
#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]) + BARF_UNLESS_AN_ARRAY(x))


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - overflow helper
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#define bitsizeof(x)  (CHAR_BIT * sizeof(x))
#define maximum_signed_value_of_type(a) \
(INTMAX_MAX >> (bitsizeof(intmax_t) - bitsizeof(a)))

#define maximum_unsigned_value_of_type(a) \
(UINTMAX_MAX >> (bitsizeof(uintmax_t) - bitsizeof(a)))


/*
 * Signed integer overflow is undefined in C, so here's a helper macro
 * to detect if the sum of two integers will overflow.
 *
 * Requires: a >= 0, typeof(a) equals typeof(b)
 */
#define signed_add_overflows(a, b) \
((b) > maximum_signed_value_of_type(a) - (a))

#define unsigned_add_overflows(a, b) \
((b) > maximum_unsigned_value_of_type(a) - (a))

/*
 * Returns true if the multiplication of "a" and "b" will
 * overflow. The types of "a" and "b" must match and must be unsigned.
 * Note that this macro evaluates "a" twice!
 */
#define unsigned_mult_overflows(a, b) \
((a) && (b) > maximum_unsigned_value_of_type(a) / (a))

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - compiler extenstion
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#ifdef __GNUC__
#define TYPEOF(x) (__typeof__(x))
#else
#define TYPEOF(x)
#endif

#if defined(__HP_cc) && (__HP_cc >= 61000)
#define NORETURN __attribute__((noreturn))
#define NORETURN_PTR
#elif defined(__GNUC__) && !defined(NO_NORETURN)
#define NORETURN __attribute__((__noreturn__))
#define NORETURN_PTR __attribute__((__noreturn__))
#elif defined(_MSC_VER)
#define NORETURN __declspec(noreturn)
#define NORETURN_PTR
#else
#define NORETURN
#define NORETURN_PTR
#ifndef __GNUC__
#ifndef __attribute__
#define __attribute__(x)
#endif
#endif
#endif

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - General helper functions
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/* General helper functions */
extern void vreportf(const char *prefix, const char *err, va_list params);
extern NORETURN void usage(const char *err);
extern NORETURN void usagef(const char *err, ...) __attribute__((format (printf, 1, 2)));
extern NORETURN void die(const char *err, ...) __attribute__((format (printf, 1, 2)));
extern NORETURN void die_errno(const char *err, ...) __attribute__((format (printf, 1, 2)));
extern int error(const char *err, ...) __attribute__((format (printf, 1, 2)));
extern int error_errno(const char *err, ...) __attribute__((format (printf, 1, 2)));
extern void warning(const char *err, ...) __attribute__((format (printf, 1, 2)));
extern void warning_errno(const char *err, ...) __attribute__((format (printf, 1, 2)));

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Memory Management
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

static inline size_t st_mult(size_t a, size_t b)
{
    if (unsigned_mult_overflows(a, b)) {
        die("size_t overflow: %"PRIuMAX" * %"PRIuMAX, (uintmax_t)a, (uintmax_t)b);
        //die("size_t overflow: %ju * %ju", (uintmax_t)a, (uintmax_t)b);
    }
    return a * b;
}

extern char *xstrdup(const char *str);
extern void *xmalloc(size_t size);
extern void *xrealloc(void *ptr, size_t size);
extern void *xcalloc(size_t nmemb, size_t size);

/*
 * FREE_AND_NULL(ptr) is like free(ptr) followed by ptr = NULL. Note
 * that ptr is used twice, so don't pass e.g. ptr++.
 */
#define FREE_AND_NULL(p) do { free(p); (p) = NULL; } while (0)

#define ALLOC_ARRAY(x, alloc) (x) = xmalloc(st_mult(sizeof(*(x)), (alloc)))
#define CALLOC_ARRAY(x, alloc) (x) = xcalloc((alloc), sizeof(*(x)));
#define REALLOC_ARRAY(x, alloc) (x) = xrealloc((x), st_mult(sizeof(*(x)), (alloc)))

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - String Helper
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/*
 * If the string "str" begins with the string found in "prefix", return 1.
 * The "out" parameter is set to "str + strlen(prefix)" (i.e., to the point in
 * the string right after the prefix).
 *
 * Otherwise, return 0 and leave "out" untouched.
 *
 * Examples:
 *
 *   [extract branch name, fail if not a branch]
 *   if (!skip_prefix(ref, "refs/heads/", &branch)
 *    return -1;
 *
 *   [skip prefix if present, otherwise use whole string]
 *   skip_prefix(name, "refs/heads/", &name);
 */
static inline int skip_prefix(const char *str, const char *prefix,
                              const char **out)
{
    do {
        if (!*prefix) {
            *out = str;
            return 1;
        }
    } while (*str++ == *prefix++);
    return 0;
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark - Path Helper
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#ifndef find_last_dir_sep
static inline char *git_find_last_dir_sep(const char *path)
{
    return strrchr(path, '/');
}
#define find_last_dir_sep git_find_last_dir_sep
#endif

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#pragma mark -
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
extern int cmd_main(int, const char **);

#endif /* memo_compat_util_h */
