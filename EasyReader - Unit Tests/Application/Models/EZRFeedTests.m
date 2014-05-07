//
//  EZRFeedTests.m
//  EasyReader
//
//  Created by Michael Beattie on 3/28/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZRBaseModelTests.h"

// Models
#import "Feed.h"
#import "FeedItem.h"

@interface Feed (Test)

+ (void) saveParsedResponseData:(id)responseData;

@end


@interface EZRFeedTests : EZRBaseModelTests

@end


@implementation EZRFeedTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCreateFeedWithUrl
{
    [[mockAPIClient expect] requestRoute:@"feedCreate"
                              parameters:[OCMArg any]
                                 success:[OCMArg any]
                                 failure:[OCMArg any]];
    
    [Feed createFeedWithUrl:@""
                    success:nil
                    failure:nil];
    
    [mockAPIClient verify];
}

- (void)testRequestDefaultFeeds
{
    [[mockAPIClient expect] requestRoute:@"feedDefaults"
                              parameters:[OCMArg any]
                                 success:[OCMArg any]
                                 failure:[OCMArg any]];
    
    [Feed requestDefaultFeedsWithSuccess:nil
                                 failure:nil];
    
    [mockAPIClient verify];
}

- (void)testRequestFeedsByName
{
    [[mockAPIClient expect] requestRoute:@"feedSearch"
                              parameters:[OCMArg any]
                                 success:[OCMArg any]
                                 failure:[OCMArg any]];
    
    [Feed requestFeedsByName:@""
                     success:nil
                     failure:nil];
    
    [mockAPIClient verify];
}

- (void)testSaveParsedResponseData
{
    NSDictionary *response = @{
                               @"feeds":@[
                                       @{
                                           @"id":@1
                                           },
                                       @{
                                           @"id":@2
                                           }
                                       ]};

    [Feed saveParsedResponseData:response];

    BOOL assert = [[Feed MR_findAll] count] == 2;
    XCTAssertTrue(assert, @"");
}

- (void)testPurgeOldFeedItems
{
    Feed *feed = [Feed MR_createEntity];
    [feed setId:@1];
    
    for (int i = 0; i <= 10; i++) {
        FeedItem *feedItem = [FeedItem MR_createEntity];
        [feedItem setFeed:feed];
    }
    
    // Check that we have more than 10 feeds before running purge
    BOOL assert1 = [[FeedItem MR_findAll] count] == 11;
    XCTAssertTrue(assert1, @"");
    
    [feed purgeOldFeedItems];
    
    BOOL assert2 = [[FeedItem MR_findAll] count] == 10;
    XCTAssertTrue(assert2, @"");
}

@end
