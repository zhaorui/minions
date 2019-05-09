//
//  main.m
//  booster
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <sys/kern_control.h>
#include <sys/kern_event.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <string.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        struct sockaddr_ctl addr;
        struct ctl_info info;
        int fd = socket(AF_SYSTEM, SOCK_DGRAM, SYSPROTO_CONTROL);
        if (fd < 0) return -1;
        
        bzero(&info, sizeof(info));
        strncpy(info.ctl_name, "com.apple.net.utun_control", sizeof(info.ctl_name));
        
        // get id of utun kctl
        if (ioctl(fd, CTLIOCGINFO, &info)) {
            close(fd);
            return -1;
        }
        
        
        addr.sc_len = sizeof(addr);
        addr.sc_family = AF_SYSTEM;
        addr.ss_sysaddr = AF_SYS_CONTROL; //AF_SYS_KERNCONTROL;
        addr.sc_id = info.ctl_id;
        addr.sc_unit = 10;
        
        if (connect(fd, (struct sockaddr *)&addr, sizeof(addr))) {
            perror("connect");
            close(fd);
            return -1;
        }
        
        char *utun_if_name;
        socklen_t len = sizeof(utun_if_name);
        if (getsockopt(fd, SYSPROTO_CONTROL, 2, &utun_if_name, &len)) {
            perror("getsockopt");
            close(fd);
            return -1;
        }
        printf("tunnel iterface: %s\n", utun_if_name);
        
    }
    return 0;
}
