//
//  EZRMenuSearchControllerTests.m
//  EasyReader
//
//  Created by Alfredo Uribe on 4/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>

// Models
#import "Feed.h"

#import "EZRBaseControllerTests.h"
#import "EZRMenuSearchController.h"


@interface EZRMenuSearchController (Test)

- (BOOL)isURL:(NSString *)string;
- (void)search:(NSString*)searchText;
- (void)postSearchStateChangeNotification:(EZRSearchState)state;

@end

@interface EZRMenuSearchControllerTests : EZRBaseControllerTests
{
    EZRMenuSearchController *controller;
}
@end

@implementation EZRMenuSearchControllerTests

- (void)setUp
{
    [super setUp];
    controller = [[EZRMenuSearchController alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testIsURLForHttp
{
    XCTAssertTrue([controller isURL:@"http://www.test.com"],@"");
}

- (void)testIsURLForHttps
{
    XCTAssertTrue([controller isURL:@"https://www.test.com"],@"");
}

- (void)testIsURLWithWrongString
{
    XCTAssertFalse([controller isURL:@"www.test.com"],@"");
}

- (void)testSearch
{
    id mockFeed = [OCMockObject mockForClass:[Feed class]];
    [[mockFeed expect] requestFeedsByName:@"test"
                                  success:[OCMArg any]
                                  failure:[OCMArg any]];
    
    [controller search:@"test"];
    
    [mockAPIClient verify];
}

- (void)testSearchCancel
{
    [[mockAPIClient expect] requestRoute:@"feedSearch"
                              parameters:[OCMArg any]
                                 success:[OCMArg any]
                                 failure:[OCMArg any]];
    
    [controller search:@"test1"];
    
    [[mockAPIClient expect] cancelOperationsForRoute:@"feedSearch"
                                          parameters:@{@"name": @"test1"}];
    
    [[mockAPIClient expect] requestRoute:@"feedSearch"
                              parameters:[OCMArg any]
                                 success:[OCMArg any]
                                 failure:[OCMArg any]];
    
    [controller search:@"test2"];
    
    [mockAPIClient verify];
}

@end
