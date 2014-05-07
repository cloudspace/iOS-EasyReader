//
//  EZRFeedItemUpdateServiceTests.m
//  EasyReader
//
//  Created by Alfredo Uribe on 4/21/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZRBaseServiceTests.h"
#import "EZRFeedItemUpdateService.h"
#import "FeedItem.h"
#import "Feed.h"

@interface EZRFeedItemUpdateService (Test)

- (void)requestFiveMinutesOfFeedItems:(id)sender;
- (void)requestOneWeekOfFeedItems;
- (void)requestFeedItemsSince:(NSDate *)since;
- (void)loadDefaultFeeds;
- (BOOL)hasSetDefaultFeeds;

@end

@interface EZRFeedItemUpdateServiceTests : EZRBaseServiceTests
{
    id mockService;
    id partialMockService;
    id mockFeedItem;
    id mockFeed;
}
@end

@implementation EZRFeedItemUpdateServiceTests

- (void)setUp
{
    [super setUp];
    mockService = [OCMockObject mockForClass:[EZRFeedItemUpdateService class]];
    partialMockService = [OCMockObject partialMockForObject:[[EZRFeedItemUpdateService alloc] init]];
    mockFeedItem = [OCMockObject mockForClass:[FeedItem class]];
    mockFeed = [OCMockObject mockForClass:[Feed class]];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testRequestFiveMinutesOfFeedItems
{
    [[partialMockService expect] requestFeedItemsSince:[OCMArg any]];
    
    [partialMockService requestFiveMinutesOfFeedItems:[OCMArg any]];
    [partialMockService verify];
}

- (void)testRequestOneWeekOfFeedItems
{
    [[partialMockService expect] requestFeedItemsSince:[OCMArg any]];
    
    [partialMockService requestOneWeekOfFeedItems];
    [partialMockService verify];
}

- (void)testRequestFeedItemsSince
{
    id date = [OCMockObject mockForClass:[NSDate class]];
    
    [[mockFeedItem expect] requestFeedItemsFromFeeds:[OCMArg any]
                                               since:date
                                             success:[OCMArg any]
                                             failure:[OCMArg any]];

    [partialMockService requestFeedItemsSince:date];
    [partialMockService verify];
}

- (void)testLoadDefaultFeeds
{
    [[mockFeed expect] requestDefaultFeedsWithSuccess:[OCMArg any] failure:[OCMArg any]];
    [partialMockService loadDefaultFeeds];
    [partialMockService verify];
}

@end
