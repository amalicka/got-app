//
//  GotAppTests.m
//  GotAppTests
//
//  Created by Ola Skierbiszewska on 08.08.2016.
//  Copyright © 2016 Ola Skierbiszewska. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StringConstants.h"

@interface GotAppTests : XCTestCase

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation GotAppTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.session = [NSURLSession sharedSession];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testDataTask{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURL *url = [NSURL URLWithString:kMainUrl];
    NSURLSessionTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        XCTAssertNil(error, @"dataTaskWithURL error %@", error);
        
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *) response statusCode];
            XCTAssertEqual(statusCode, 200, @"status code was not 200; was %ld", statusCode);
        }
        XCTAssert(data, @"data nil");
        
        if(data){
            NSError *errorJ = nil;
            NSDictionary *json= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJ];
            
            XCTAssert([json valueForKey: kBasepath], @"base path for wiki not found");
            XCTAssert([json valueForKey: kItems], @"items not found in loaded data");
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    [task resume];
    
    long rc = dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 60.0 * NSEC_PER_SEC));
    XCTAssertEqual(rc, 0, @"network request timed out");
}

@end
