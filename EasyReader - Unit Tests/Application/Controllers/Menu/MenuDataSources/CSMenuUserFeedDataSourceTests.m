//
//  CSMenuUserFeedDataSource.m
//  EasyReader
//
//  Created by Michael Beattie on 3/28/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZRBaseControllerTests.h"
#import "EZRMenuUserFeedDataSource.h"

// Menu Cells
#import "EZRMenuFeedCell.h"

// Models
#import "Feed.h"
#import "FeedItem.h"
#import "User.h"

@interface EZRMenuUserFeedDataSource(Test)

- (void)sortFeeds;
- (void)setFeed:(Feed *)feed forUserFeedCell:(EZRMenuFeedCell *)cell;

@end

@interface CSMenuUserFeedDataSourceTests : EZRBaseControllerTests
{
    EZRMenuUserFeedDataSource *userFeedDataSource;
}
@end

@implementation CSMenuUserFeedDataSourceTests

- (void)setUp
{
    [super setUp];
    userFeedDataSource = [[EZRMenuUserFeedDataSource alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testUpdateWithFeeds
{
    Feed *feed = [Feed MR_createEntity];
    [feed setName:@"A"];
    
    NSMutableSet *feedSet = [[NSMutableSet alloc] init];
    [feedSet addObject:feed];
    
    [userFeedDataSource updateWithFeeds:feedSet];
    
    BOOL assert = [userFeedDataSource.feeds count] == 1;
    XCTAssertTrue(assert, @"");
}

- (void)testSortFeeds
{
    NSMutableSet *feedSet = [[NSMutableSet alloc] init];
    
    Feed *feed1 = [Feed MR_createEntity];
    [feed1 setName:@"B"];
    [feedSet addObject:feed1];
    Feed *feed2 = [Feed MR_createEntity];
    [feed2 setName:@"A"];
    [feedSet addObject:feed2];
    
    userFeedDataSource.feeds = feedSet;
    
    [userFeedDataSource sortFeeds];
    
    BOOL assert = [((Feed *)[userFeedDataSource.sortedFeeds objectAtIndex:0]) isEqual:feed2];
    XCTAssertTrue(assert, @"");
}

- (void)testSetFeedForUserFeedCell
{
    EZRMenuFeedCell *cell = [[EZRMenuFeedCell alloc] init];
    Feed *feed = [Feed MR_createEntity];
    [feed setName:@"A"];
    
    [userFeedDataSource setFeed:feed forUserFeedCell:cell];
    
    BOOL assert = [((Feed *)cell.feed) isEqual:feed];
    XCTAssertTrue(assert, @"");
}

@end
