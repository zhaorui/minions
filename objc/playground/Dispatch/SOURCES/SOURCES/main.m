//
//  main.m
//  SOURCES
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ALILANG_CLIENT_LOG_DIR "/Users/zhaorui/Library/Logs/AliLangClient"

static dispatch_queue_t com_alibaba_logdir_monitor_queue() {
    static dispatch_queue_t _queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _queue = dispatch_queue_create("com.alibaba.logdir.monitor.queue", DISPATCH_QUEUE_SERIAL);
    });
    return _queue;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int log_dir_fd = open(ALILANG_CLIENT_LOG_DIR, O_EVTONLY);
        if (log_dir_fd < 0) {
            perror("open");
        }
        dispatch_source_t log_dir_monitor =
        dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                               log_dir_fd,
                               DISPATCH_VNODE_WRITE, com_alibaba_logdir_monitor_queue());
        dispatch_source_set_event_handler(log_dir_monitor, ^{
            // notice writting at ~/Library/Logs/AliLangClient
            // probably AlilangClient create new log file
            printf("some thing is write to the folder...\n");
        });
        
        dispatch_source_set_cancel_handler(log_dir_monitor, ^{
            close(log_dir_fd);
        });
        
        dispatch_resume(log_dir_monitor);
        dispatch_main();
    }
    return 0;
}
