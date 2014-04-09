//
//  CSMenuSearchFeedDataSourceTests.m
//  EasyReader
//
//  Created by Michael Beattie on 3/28/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZRBaseControllerTests.h"
#import "EZRMenuSearchFeedDataSource.h"

// Menu Cells
#import "EZRSearchFeedCell.h"
#import "EZRMenuAddFeedCell.h"

// Models
#import "Feed.h"
#import "FeedItem.h"
#import "User.h"

@interface EZRMenuSearchFeedDataSource(Test)

- (void)sortFeeds;
- (void)setFeedData:(NSDictionary *)feedData forSearchFeedCell:(EZRSearchFeedCell *)cell;
- (void)setFeedData:(NSDictionary *)feedData forCustomFeedCell:(EZRMenuAddFeedCell *)cell;

@end

@interface CSMenuSearchFeedDataSourceTests : EZRBaseControllerTests
{
    EZRMenuSearchFeedDataSource *searchFeedDataSource;
}
@end

@implementation CSMenuSearchFeedDataSourceTests

- (void)setUp
{
    [super setUp];
    searchFeedDataSource = [[EZRMenuSearchFeedDataSource alloc] init];
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
    
    [searchFeedDataSource updateWithFeeds:feedSet];
    
    BOOL assert = [searchFeedDataSource.feeds count] == 1;
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
    
    searchFeedDataSource.feeds = feedSet;
    
    [searchFeedDataSource sortFeeds];
    
    BOOL assert = [((Feed *)[searchFeedDataSource.sortedFeeds objectAtIndex:0]) isEqual:feed2];
    XCTAssertTrue(assert, @"");
}

- (void)testSetFeedForSearchFeedCell
{
    EZRSearchFeedCell *cell = [[EZRSearchFeedCell alloc] init];
    
    NSDictionary *feedData = @{@"url" : @"search"};
    
    [searchFeedDataSource setFeedData:feedData forSearchFeedCell:cell];
    
    BOOL assert = [((NSDictionary *)cell.feedData) isEqual:feedData];
    XCTAssertTrue(assert, @"");
}


- (void)testSetFeedForCustomFeedCell
{
    EZRMenuAddFeedCell *cell = [[EZRMenuAddFeedCell alloc] init];
    
    NSDictionary *feedData = @{@"url" : @"custom"};
    
    [searchFeedDataSource setFeedData:feedData forCustomFeedCell:cell];
    
    BOOL assert = [((NSDictionary *)cell.feedData) isEqual:feedData];
    XCTAssertTrue(assert, @"");
}


@end
