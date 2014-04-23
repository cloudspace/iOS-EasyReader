//
//  EZRUserTests.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/19/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZRBaseModelTests.h"

// Models
#import "User.h"
#import "Feed.h"
#import "FeedItem.h"


/**
 * User model tests
 */
@interface EZRUserTests : EZRBaseModelTests

@end

@implementation EZRUserTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testCurrentWithNoSharedInstanceSet
{
    [User current];
    XCTAssertTrue([[User MR_findAll] count] == 1, @"");
}

- (void)testCurrentWithSetSharedInstance
{
    [User current];
    User *currentUser = [[User MR_findAll] firstObject];
    XCTAssertTrue([currentUser isEqual:[User current]], @"");
}


- (void)testFeedItems
{
    User *user = [User MR_createEntity];
    
    Feed *feed1 = [Feed MR_createEntity];
    Feed *feed2 = [Feed MR_createEntity];
    
    FeedItem *feedItem1 = [FeedItem MR_createEntity];
    FeedItem *feedItem2 = [FeedItem MR_createEntity];
    
    [feed1 addFeedItemsObject:feedItem1];
    [feed2 addFeedItemsObject:feedItem2];
    
    [user addFeeds:[NSSet setWithObjects:feed1, feed2, nil]];
    
    BOOL assert = [[user feedItems] isEqualToSet:[NSSet setWithObjects:feedItem1, feedItem2, nil]];
    XCTAssertTrue(assert, @"");
}

-(void) testHasFeedWithURL
{
    Feed *feed1 = [Feed MR_createEntity];
    [feed1 setUrl:@"test1"];
    
    Feed *feed2 = [Feed MR_createEntity];
    [feed2 setUrl:@"test2"];
    
    User *user = [User MR_createEntity];
    [user addFeeds:[NSSet setWithObjects:feed1, feed2, nil]];
    
    XCTAssertTrue([user hasFeedWithURL:@"test1"], @"");
}

@end
