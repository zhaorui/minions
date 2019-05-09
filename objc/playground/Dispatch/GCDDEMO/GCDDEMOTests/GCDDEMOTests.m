//
//  GCDDEMOTests.m
//  GCDDEMOTests
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <XCTest/XCTest.h>

static dispatch_queue_t lowest_priotiry_global_queue(void) {
    static dispatch_once_t onceToken;
    static dispatch_queue_t _queue;
    dispatch_once(&onceToken, ^{
        _queue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
    });
    return _queue;
}

static dispatch_queue_t default_priotiry_global_queue(void) {
    static dispatch_once_t onceToken;
    static dispatch_queue_t _queue;
    dispatch_once(&onceToken, ^{
        _queue = dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0);
    });
    return _queue;
}

static dispatch_queue_t higest_priotiry_global_queue(void) {
    static dispatch_once_t onceToken;
    static dispatch_queue_t _queue;
    dispatch_once(&onceToken, ^{
        _queue = dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0);
    });
    return _queue;
}

static dispatch_queue_t my_serial_queue(void) {
    static dispatch_once_t onceToken;
    static dispatch_queue_t _queue;
    dispatch_once(&onceToken, ^{
        _queue = dispatch_queue_create("com.zhaorui.my.serial.queue", DISPATCH_QUEUE_SERIAL);
    });
    return _queue;
}

@interface GCDDEMOTests : XCTestCase

@end

@implementation GCDDEMOTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testDispatchSource {
    //创建source，以DISPATCH_SOURCE_TYPE_DATA_ADD的方式进行累加，而DISPATCH_SOURCE_TYPE_DATA_OR是对结果进行二进制或运算
    dispatch_source_t source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, my_serial_queue());
    
    //事件触发后执行的句柄
    dispatch_source_set_event_handler(source,^{
        NSLog(@"监听函数：%lu",dispatch_source_get_data(source));
    });
    
    //开启source
    dispatch_resume(source);
    
    dispatch_semaphore_t _s = dispatch_semaphore_create(0);
    dispatch_async(default_priotiry_global_queue(), ^ {
        
        for(int i = 1; i <= 4; i ++){
            
            NSLog(@"~~~~~~~~~~~~~~%d", i);
            
            //触发事件，向source发送事件，这里i不能为0，否则触发不了事件
            dispatch_source_merge_data(source,i);
            
            //当Interval的事件越长，则每次的句柄都会触发
            [NSThread sleepForTimeInterval:2.0];
        }
        dispatch_semaphore_signal(_s);
    });
    dispatch_semaphore_wait(_s, DISPATCH_TIME_FOREVER);
}

- (void)testDispatchTimerSource {
    dispatch_semaphore_t _s = dispatch_semaphore_create(0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, my_serial_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        static int count = 0;
        count++;
        if (count > 5) {
            dispatch_semaphore_signal(_s);
        } else {
            printf("hit timer\n");
        }
    });
    dispatch_resume(timer);
    dispatch_semaphore_wait(_s, DISPATCH_TIME_FOREVER);
    
}

- (void)testDispatchProcSource {
    dispatch_semaphore_t _s = dispatch_semaphore_create(0);
    NSArray *appList = [NSRunningApplication
                        runningApplicationsWithBundleIdentifier:@"com.google.Chrome"];
    
    if (appList.count == 0 ) {
        return;
    }
    
    NSRunningApplication *chromeApp = appList[0];
    dispatch_source_t proc = dispatch_source_create(DISPATCH_SOURCE_TYPE_PROC, chromeApp.processIdentifier, DISPATCH_PROC_EXIT, my_serial_queue());
    dispatch_source_set_event_handler(proc, ^{
        printf("chrome is exit.\n");
        dispatch_semaphore_signal(_s);
    });
    dispatch_resume(proc);
    dispatch_semaphore_wait(_s, DISPATCH_TIME_FOREVER);
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
