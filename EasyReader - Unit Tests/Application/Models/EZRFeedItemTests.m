//
//  EZRFeedItemTests.m
//  EasyReader
//
//  Created by Alfredo Uribe on 3/27/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZRBaseModelTests.h"

// Categories
#import "NSDate+TimeAgo.h"

// Models
#import "FeedItem.h"
#import "Feed.h"
#import "User.h"

@interface FeedItem (Test)

- (NSString *)feedName;
- (NSString *)headline;
+ (void) saveParsedResponseData:(id)responseData;

@end


@interface EZRFeedItemTests : EZRBaseModelTests

@end


@implementation EZRFeedItemTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testFeedName
{
    Feed *feed = [Feed MR_createEntity];
    [feed setName:@"test"];
    
    FeedItem *feedItem = [FeedItem MR_createEntity];
    [feed addFeedItemsObject:feedItem];
    
    XCTAssertTrue([[feedItem feedName] isEqualToString:@"test"], @"");
}

- (void)testHeadline
{
    FeedItem *feedItem = [FeedItem MR_createEntity];
    NSDate *today = [NSDate date];
    [feedItem setUpdatedAt:today];

    BOOL assert = [[feedItem headline] isEqualToString:[NSString stringWithFormat:@"%@ \u00b7 %@",
                                                       [feedItem feedName],
                                                       [[feedItem updatedAt] timeAgo]]];
    XCTAssertTrue(assert, @"");
}

- (void)testRequestFeedItemsFromFeeds
{
    [[mockAPIClient expect] requestRoute:@"feedItems"
                              parameters:[OCMArg any]
                                 success:[OCMArg any]
                                 failure:[OCMArg any]];
    
    Feed *feed = [Feed MR_createEntity];
    [feed setId:@1];
    
    [FeedItem requestFeedItemsFromFeeds:[NSSet setWithObject:feed]
                                  since:[NSDate date]
                                success:nil
                                failure:nil];
        
    [mockAPIClient verify];
}

- (void)testSaveParsedResponseData
{
    Feed *feed1 = [Feed MR_createEntity];
    [feed1 setId:@1];
    
    Feed *feed2 = [Feed MR_createEntity];
    [feed2 setId:@2];
    
    User *user = [User current];
    [user setFeeds:[NSSet setWithObjects:feed1,feed2, nil]];
    
    NSDictionary *response = @{
                           @"feed_items":@[
                                @{
                                    @"feed_id":@1
                                  },
                                @{
                                    @"feed_id":@2
                                  }
                           ]};
    
    [FeedItem saveParsedResponseData:response];
    
    BOOL assert = [[FeedItem MR_findAll] count] == 2;
    XCTAssertTrue(assert, @"");
}

@end
