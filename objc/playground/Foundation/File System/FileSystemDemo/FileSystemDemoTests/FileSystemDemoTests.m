//
//  FileSystemDemoTests.m
//  FileSystemDemoTests
//
//  Created by 赵睿 on 2/26/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <XCTest/XCTest.h>

static NSString* calculator = @"/Applications/Calculator.app/Contents/MacOS/Calculator";
static NSString* downloads = @"~/Downloads";
static NSString* newfile = @"~/CocoaTest/FileSystemDemo/newfile";
static NSString* homefile = @"~/hellothere";

@interface FileSystemDemoTests : XCTestCase

@end

@implementation FileSystemDemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testNSFileManager {
    BOOL isFolder;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:calculator
                                                        isDirectory:&isFolder];
    XCTAssertTrue(isExist && !isFolder);
    
    // ~ is not recognized so this would fail
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:downloads
                                                   isDirectory:&isFolder];
    XCTAssertFalse(isExist && isFolder);
    
    isExist = [[NSFileManager defaultManager] fileExistsAtPath: [downloads stringByStandardizingPath]
                                                   isDirectory:&isFolder];
    
    XCTAssertTrue(isExist && isFolder);
}

- (void)testNSFileManagerCreateAndRemove {
    BOOL success = NO;
    
    // the file is in ~/Library/Containers/com.zhaorui.FileSystemDemo/Data if sandbox is enabled
    success = [[NSFileManager defaultManager] createFileAtPath:[homefile stringByStandardizingPath]
                                                      contents:nil
                                                    attributes:nil];
    XCTAssertTrue(success);
    
    // intermediate directory is not exist, create would fail
    success = [[NSFileManager defaultManager] createFileAtPath:[newfile stringByStandardizingPath]
                                                      contents:nil
                                                    attributes:nil];
    XCTAssertFalse(success);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
