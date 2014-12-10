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

+ (void)requestFiveMinutesOfFeedItems:(id)sender;
+ (void)requestOneWeekOfFeedItems;
+ (void)requestFeedItemsSince:(NSDate *)since;
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
    [[[mockService expect] classMethod] requestFeedItemsSince:[OCMArg any]];
    
    [[mockService class] requestFiveMinutesOfFeedItems:[OCMArg any]];
    
    [mockService verify];
}

- (void)testRequestOneWeekOfFeedItems
{
    [[[mockService expect] classMethod] requestFeedItemsSince:[OCMArg any]];
    
    [[mockService class] requestOneWeekOfFeedItems];
    
    [mockService verify];
}

- (void)testRequestFeedItemsSince
{
    id date = [OCMockObject mockForClass:[NSDate class]];
    
    [[[mockFeedItem expect] classMethod] requestFeedItemsFromFeeds:[OCMArg any]
                                                             since:date
                                                           success:[OCMArg any]
                                                           failure:[OCMArg any]];

    [[mockService class] requestFeedItemsSince:date];
    
    [mockService verify];
}

- (void)testLoadDefaultFeeds
{
    [[mockFeed expect] requestDefaultFeedsWithSuccess:[OCMArg any] failure:[OCMArg any]];
    [partialMockService loadDefaultFeeds];
    [partialMockService verify];
}

@end
