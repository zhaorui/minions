//
//  ViewController.m
//  GCDDEMO
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import "ViewController.h"

#define ALILANG_CLIENT_LOG_DIR "/Users/zhaorui/Library/Logs/AliLangClient"

static dispatch_queue_t com_alibaba_logdir_monitor_queue() {
    static dispatch_queue_t _queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _queue = dispatch_queue_create("com.alibaba.logdir.monitor.queue", DISPATCH_QUEUE_SERIAL);
    });
    return _queue;
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // dispatch_source monitor log directory
    if ((self.log_dir_fd = open(ALILANG_CLIENT_LOG_DIR, O_EVTONLY)) == -1) {
        perror("open");
    }
    self.log_dir_monitor  =
    dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                           self.log_dir_fd,
                           DISPATCH_VNODE_WRITE, com_alibaba_logdir_monitor_queue());
    dispatch_source_set_event_handler(self.log_dir_monitor, ^{
        // notice writting at ~/Library/Logs/AliLangClient
        // probably AlilangClient create new log file
        NSLog(@"sommeting write to the log directory");
    });
    
    dispatch_resume(self.log_dir_monitor);
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
