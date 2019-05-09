//
//  tun.h
//  booster
//
//  Created by 赵睿 on 5/3/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#ifndef tun_h
#define tun_h

#include <stdio.h>
#include <stdbool.h>

/*
 * Define a TUN/TAP dev.
 */

struct tuntap
{
#define TUNNEL_TYPE(tt) ((tt) ? ((tt)->type) : DEV_TYPE_UNDEF)
    int type; /* DEV_TYPE_x as defined in proto.h */
    
#define TUNNEL_TOPOLOGY(tt) ((tt) ? ((tt)->topology) : TOP_UNDEF)
    int topology; /* one of the TOP_x values */
    
    char *actual_name; /* actual name of TUN/TAP dev, usually including unit number */
    
    /* number of TX buffers */
    int txqueuelen;
    
    /* ifconfig parameters */
    in_addr_t local;
    in_addr_t remote_netmask;
    in_addr_t broadcast;
    

    int fd; /* file descriptor for TUN/TAP dev */
    bool is_utun;
    
    /* used for printing status info only */
    unsigned int rwflags_debug;
    
    /* Some TUN/TAP drivers like to be ioctled for mtu
     * after open */
    int post_open_mtu;
};

#endif /* tun_h */
