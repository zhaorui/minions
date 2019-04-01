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
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    BOOL isExist = [fileMgr fileExistsAtPath:calculator
                                 isDirectory:&isFolder];
    XCTAssertTrue(isExist && !isFolder);
    
    // ~ is not recognized so this would fail
    isExist = [[NSFileManager defaultManager] fileExistsAtPath:downloads
                                                   isDirectory:&isFolder];
    XCTAssertFalse(isExist && isFolder);
    
    isExist = [fileMgr fileExistsAtPath: [downloads stringByStandardizingPath]
                            isDirectory:&isFolder];
    
    XCTAssertTrue(isExist && isFolder);
}

- (void)testNSFileManagerCreateAndRemove {
    BOOL success = NO;
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    
    // the file is in ~/Library/Containers/com.zhaorui.FileSystemDemo/Data if sandbox is enabled
    success = [fileMgr createFileAtPath:[homefile stringByStandardizingPath]
                               contents:nil
                             attributes:nil];
    XCTAssertTrue(success);
    
    // intermediate directory is not exist, create would fail
    success = [fileMgr createFileAtPath:[newfile stringByStandardizingPath]
                               contents:nil
                             attributes:nil];
    XCTAssertFalse(success);
}

- (void)testDiscoveringDirContents {
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSString* downloadPath = [downloads stringByStandardizingPath];
    NSURL* downloadURL = [NSURL URLWithString:downloadPath];
    
    //subPathsAtPath:
    NSArray* paths = [fileMgr subpathsAtPath:downloadPath];
    NSArray* paths2 = [fileMgr subpathsOfDirectoryAtPath:downloadPath
                                                   error:nil];
    XCTAssertTrue([paths isEqualToArray:paths2]);
    
    NSDirectoryEnumerator *dirEnum = [fileMgr enumeratorAtPath:downloadPath];
    
    NSString *file;
    NSMutableArray* allpaths = [NSMutableArray new];
    while ((file = [dirEnum nextObject])) {
        [allpaths addObject:file];
    }
    
    NSMutableArray* mutableFileURLs = [NSMutableArray new];
    NSDirectoryEnumerator *directoryEnumerator =
    [fileMgr enumeratorAtURL:downloadURL
  includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey]
                     options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
    
    for (NSURL* fileURL in directoryEnumerator) {
        NSNumber *isDirectory = nil;
        [fileURL getResourceValue:&isDirectory
                           forKey:NSURLIsDirectoryKey
                            error:nil];
        
        if ([isDirectory boolValue]) {
            NSString *name = nil;
            [fileURL getResourceValue:&name forKey:NSURLNameKey error:nil];
            
            if ([name isEqualToString:@".git"]) {
                [directoryEnumerator skipDescendants];
            } else {
                [mutableFileURLs addObject:fileURL];
            }
        }
    }
    
    NSLog(@"%@", mutableFileURLs);
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
