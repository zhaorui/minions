//
//  string-list.h
//  memo
//
//  Created by 赵睿 on 3/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#ifndef string_list_h
#define string_list_h

/**
 * The string_list API offers a data structure and functions to handle
 * sorted and unsorted arrays of strings.  A "sorted" list is one whose
 * entries are sorted by string value in `strcmp()` order.
 *
 * The caller:
 *
 * . Allocates and clears a `struct string_list` variable.
 *
 * . Initializes the members. You might want to set the flag `strdup_strings`
 *   if the strings should be strdup()ed. For example, this is necessary
 *   when you add something like git_path("..."), since that function returns
 *   a static buffer that will change with the next call to git_path().
 *
 * If you need something advanced, you can manually malloc() the `items`
 * member (you need this if you add things later) and you should set the
 * `nr` and `alloc` members in that case, too.
 *
 * . Adds new items to the list, using `string_list_append`,
 *   `string_list_append_nodup`, `string_list_insert`,
 *   `string_list_split`, and/or `string_list_split_in_place`.
 *
 * . Can check if a string is in the list using `string_list_has_string` or
 *   `unsorted_string_list_has_string` and get it from the list using
 *   `string_list_lookup` for sorted lists.
 *
 * . Can sort an unsorted list using `string_list_sort`.
 *
 * . Can remove duplicate items from a sorted list using
 *   `string_list_remove_duplicates`.
 *
 * . Can remove individual items of an unsorted list using
 *   `unsorted_string_list_delete_item`.
 *
 * . Can remove items not matching a criterion from a sorted or unsorted
 *   list using `filter_string_list`, or remove empty strings using
 *   `string_list_remove_empty_items`.
 *
 * . Finally it should free the list using `string_list_clear`.
 *
 * Example:
 *
 *     struct string_list list = STRING_LIST_INIT_NODUP;
 *     int i;
 *
 *     string_list_append(&list, "foo");
 *     string_list_append(&list, "bar");
 *     for (i = 0; i < list.nr; i++)
 *             printf("%s\n", list.items[i].string)
 *
 * NOTE: It is more efficient to build an unsorted list and sort it
 * afterwards, instead of building a sorted list (`O(n log n)` instead of
 * `O(n^2)`).
 *
 * However, if you use the list to check if a certain string was added
 * already, you should not do that (using unsorted_string_list_has_string()),
 * because the complexity would be quadratic again (but with a worse factor).
 */

/**
 * Represents an item of the list. The `string` member is a pointer to the
 * string, and you may use the `util` member for any purpose, if you want.
 */
struct string_list_item {
    char *string;
    void *util;
};

typedef int (*compare_strings_fn)(const char *, const char *);

/**
 * Represents the list itself.
 *
 * . The array of items are available via the `items` member.
 * . The `nr` member contains the number of items stored in the list.
 * . The `alloc` member is used to avoid reallocating at every insertion.
 *   You should not tamper with it.
 * . Setting the `strdup_strings` member to 1 will strdup() the strings
 *   before adding them, see above.
 * . The `compare_strings_fn` member is used to specify a custom compare
 *   function, otherwise `strcmp()` is used as the default function.
 */
struct string_list {
    struct string_list_item *items;
    unsigned int nr, alloc;
    unsigned int strdup_strings:1;
    compare_strings_fn cmp; /* NULL uses strcmp() */
};

#define STRING_LIST_INIT_NODUP { NULL, 0, 0, 0, NULL }
#define STRING_LIST_INIT_DUP   { NULL, 0, 0, 1, NULL }

/* General functions which work with both sorted and unsorted lists. */

/**
 * Initialize the members of the string_list, set `strdup_strings`
 * member according to the value of the second parameter.
 */
void string_list_init(struct string_list *list, int strdup_strings);

/** Iterate over each item, as a macro. */
#define for_each_string_list_item(item,list)            \
for (item = (list)->items;                      \
item && item < (list)->items + (list)->nr; \
++item)

#endif /* string_list_h */
