//
//  main.m
//  LogsDemo
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <os/activity.h>

static dispatch_queue_t work_queue() {
    static dispatch_once_t onceToken;
    static dispatch_queue_t _queue;
    dispatch_once(&onceToken, ^{
        _queue = dispatch_queue_create("com.zhaorui.work.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return _queue;
}

void dowork(int done) {
    int next_done = done + 1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"work %d done", done);
        dowork(next_done);
    });
}

void test_case(void) {
    dowork(0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)),work_queue(), ^{
        NSLog(@"3s gone, 7s left...");
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)),work_queue(), ^{
        NSLog(@"Ar Oh, time to crash!"); // actually no need to crash
        //assert(false);
    });
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Activity Tracing
        //os_activity_initiate("demo.os_activity_initiate", OS_ACTIVITY_FLAG_DEFAULT, ^{
        //    os_activity_set_breadcrumb("breadcrumb");
        //    NSLog(@"Hello");
        //    test_case();
        //});
        
        os_activity_t activity = os_activity_start("demo.os_activity_start", OS_ACTIVITY_FLAG_DEFAULT);
        test_case();
        os_activity_end(activity);
        
        os_activity_create("demo.os_activity_create", activity, OS_ACTIVITY_FLAG_DEFAULT);
        os_activity_scope_state_t state1 = {0};
        os_activity_scope_enter(activity, state1);
        
        os_activity_scope_leave(state1);
        dispatch_main();
    }
    return 0;
}
