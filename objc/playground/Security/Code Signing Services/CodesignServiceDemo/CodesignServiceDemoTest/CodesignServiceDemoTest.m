//
//  CodesignServiceDemoTest.m
//  CodesignServiceDemoTest
//
//  Created by 赵睿 on 3/20/19.
//  Copyright © 2019 com.zhaorui. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Security/Security.h>

// Private Codesign API
OSStatus SecTaskValidateForRequirement(SecTaskRef task, CFStringRef requirement);
OSStatus SecCodeCreateWithPID(pid_t, SecCSFlags, SecCodeRef*);

NSString* CalcApp = @"/Applications/Calculator.app";
CFStringRef CalcCodeReq = CFSTR("identifier \"com.apple.calculator\" and anchor apple");

@interface CodesignServiceDemoTest : XCTestCase {
    SecRequirementRef req;
}

@end

@implementation CodesignServiceDemoTest

- (void)setUp {
    OSStatus status = SecRequirementCreateWithString(CalcCodeReq, kSecCSDefaultFlags, &self->req);
    XCTAssertEqual(status, 0);
}

- (void)tearDown {
    
}

- (void)testSecRequirementCopyString {
    SecStaticCodeRef code;
    SecRequirementRef requirment;
    CFStringRef code_requirment_str;
    
    SecStaticCodeCreateWithPath((__bridge CFURLRef)[NSURL URLWithString:CalcApp], kSecCSDefaultFlags, &code);
    SecCodeCopyDesignatedRequirement(code, kSecCSDefaultFlags, &requirment);
    SecRequirementCopyString(requirment, kSecCSDefaultFlags, &code_requirment_str);
    XCTAssertTrue(CFEqual(code_requirment_str, CalcCodeReq));
}

- (void)testSecTaskValidateForRequirement {
    // How to get the audit_token of Calc app?? through XPC?
    // uid, uid, gid, uid, gid, pid, unknown, unknown
    audit_token_t token = {501, 501, 20, 501, 20, 0, 100007, 215662};
    SecTaskRef task = SecTaskCreateWithAuditToken(NULL, token);
    OSStatus status = SecTaskValidateForRequirement(task, CalcCodeReq);
    XCTAssertEqual(status, 0);
    
}

- (void)testSecCodeCreateWithPIDAndSecCodeCheckValidity {
    // https://opensource.apple.com/source/Security/Security-57740.51.3/OSX/libsecurity_codesigning/lib/SecTask.c.auto.html
    // SecTask.c explain the implementation of SecTaskValidateForRequirement
    [[NSWorkspace sharedWorkspace] launchApplication:@"/Applications/Calculator.app"];
    NSRunningApplication* calculator = [[[[NSWorkspace sharedWorkspace] runningApplications]
                                         filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:
                                          @"bundleIdentifier == 'com.apple.calculator'"]] firstObject];
    pid_t pid = [calculator processIdentifier];
    SecCodeRef running_code = NULL;
    OSStatus status = SecCodeCreateWithPID(pid, kSecCSDefaultFlags, &running_code);
    XCTAssertEqual(status, 0);
    
    status = SecCodeCheckValidity(running_code, kSecCSDefaultFlags, self->req);
    XCTAssertEqual(status, 0);
    
    [calculator terminate];
}

- (void)testSecCodeCheckValidity {
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
