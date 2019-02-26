#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import logging
import socket
import time
import socks
import numpy

from urllib.parse import urlparse
from ping import shell

@shell.exception_handle(self_=False, exit_code=1)
def main():
    config  = shell.get_config()

    
    server = config['server']
    port = config['port']
    size = config['size']
    timeout = config['timeout']
    interval = config['interval']
    max_cnt = config['count']
    proxy = config['proxy']

    udp_socket = None
    if proxy:
        o = urlparse(proxy)
        proxy_ip = o.hostname
        proxy_port = o.port

        print('proxy_ip: %s' % (proxy_ip,))
        print('proxy_port: %d' % (proxy_port,))

        udp_socket = socks.socksocket(socket.AF_INET, socket.SOCK_DGRAM)
        udp_socket.set_proxy(socks.SOCKS5, proxy_ip, proxy_port)
    else:
        udp_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    payload = 'z' * size
    ping_cnt = loss_cnt =  0
    rtt_vals = []

    while ping_cnt < max_cnt:
        snd_time = time.time()
        udp_socket.sendto(payload.encode(), (server, port))
        udp_socket.settimeout(timeout)
        try:
            recv_data, addr = udp_socket.recvfrom(65536)
            if recv_data == payload.encode() and addr[0] == server and addr[1] == port:
                rtt = (time.time()-snd_time)*1000
                rtt_vals.append(rtt)
                print("Reply from %s:%s udp_seq=%d time=%.1f ms" % (server, port, ping_cnt, rtt))
                time_left = interval * 1000 - rtt
                if (time_left > 0):
                    time.sleep(time_left / 1000)
        except socket.timeout:
            print("Request timeout for udp_seq %d" % (ping_cnt))
            loss_cnt += 1
        ping_cnt += 1
    
    # Statistics
    loss_rate = loss_cnt / max_cnt
    print("--- udp ping statistics ---")
    print("%d packets transmitted, %d packets received, %.2f%% packet loss" % (max_cnt, max_cnt-loss_cnt, loss_rate*100))
    if (len(rtt_vals)):
        rtt_min = min(rtt_vals)
        rtt_max = max(rtt_vals)
        rtt_avg = numpy.average(rtt_vals)
        rtt_stddev = numpy.std(rtt_vals)
        print("round-trip min/avg/max/stddev = %.2f/%.2f/%.2f/%.2f ms" % (rtt_min, rtt_avg, rtt_max, rtt_stddev))

if __name__ == "__main__":
    main()