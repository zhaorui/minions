//
//  common.m
//  memo
//
//  Created by 赵睿 on 4/5/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "common.h"

struct termios shell_modes;

void show_tty_info(void) {
    struct termios current_shell_modes;
    struct string_list list = STRING_LIST_INIT_NODUP;
    
    tcgetattr(STDIN_FILENO, &current_shell_modes);
    
    if (current_shell_modes.c_iflag & IGNBRK) {
        string_list_append(&list, "IGNBRK");
    } if (current_shell_modes.c_iflag & BRKINT ) {
        string_list_append(&list, "BRKINT");
    } if (current_shell_modes.c_iflag & IGNPAR ) {
        string_list_append(&list, "IGNPAR");
    } if (current_shell_modes.c_iflag & PARMRK ) {
        string_list_append(&list, "PARMRK");
    } if (current_shell_modes.c_iflag & INPCK) {
        string_list_append(&list, "INPCK");
    } if (current_shell_modes.c_iflag & ISTRIP) {
        string_list_append(&list, "ISTRIP");
    } if (current_shell_modes.c_iflag & INLCR) {
        string_list_append(&list, "INLCR");
    } if (current_shell_modes.c_iflag & IGNCR) {
        string_list_append(&list, "IGNCR");
    } if (current_shell_modes.c_iflag & ICRNL) {
        string_list_append(&list, "ICRNL");
    } if (current_shell_modes.c_iflag & IXON) {
        string_list_append(&list, "IXON");
    } if (current_shell_modes.c_iflag & IXOFF) {
        string_list_append(&list, "IXOFF");
    } if (current_shell_modes.c_iflag & IXANY) {
        string_list_append(&list, "IXANY");
    } if (current_shell_modes.c_iflag & IMAXBEL) {
        string_list_append(&list, "IMAXBEL");
    } if (current_shell_modes.c_iflag & IUTF8) {
        string_list_append(&list, "IUTF8");
    }
    
    // print out c_iflag of termios
    struct string_list_item* item;
    for_each_string_list_item(item, &list) {
        printf("%s ", item->string);
    }
    printf("\n");
    
    
}
