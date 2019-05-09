//
//  ViewController.h
//  GCDDEMO
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (assign, nonatomic) int log_dir_fd;
@property (strong, nonatomic) dispatch_source_t log_dir_monitor;

@end

