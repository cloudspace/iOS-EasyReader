//
//  CSMenuSearchFeedDataSourceTests.m
//  EasyReader
//
//  Created by Michael Beattie on 3/28/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZRBaseControllerTests.h"
#import "CSMenuSearchFeedDataSource.h"

// Menu Cells
#import "CSSearchFeedCell.h"
#import "EZRCustomFeedCell.h"

// Models
#import "Feed.h"
#import "FeedItem.h"
#import "User.h"

@interface CSMenuSearchFeedDataSource(Test)

- (void)sortFeeds;
- (void)setFeedData:(NSDictionary *)feedData forSearchFeedCell:(CSSearchFeedCell *)cell;
- (void)setFeedData:(NSDictionary *)feedData forCustomFeedCell:(EZRCustomFeedCell *)cell;

@end

@interface CSMenuSearchFeedDataSourceTests : EZRBaseControllerTests
{
    CSMenuSearchFeedDataSource *searchFeedDataSource;
}
@end

@implementation CSMenuSearchFeedDataSourceTests

- (void)setUp
{
    [super setUp];
    searchFeedDataSource = [[CSMenuSearchFeedDataSource alloc] init];
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
    CSSearchFeedCell *cell = [[CSSearchFeedCell alloc] init];
    
    NSDictionary *feedData = @{@"url" : @"search"};
    
    [searchFeedDataSource setFeedData:feedData forSearchFeedCell:cell];
    
    BOOL assert = [((NSDictionary *)cell.feedData) isEqual:feedData];
    XCTAssertTrue(assert, @"");
}


- (void)testSetFeedForCustomFeedCell
{
    EZRCustomFeedCell *cell = [[EZRCustomFeedCell alloc] init];
    
    NSDictionary *feedData = @{@"url" : @"custom"};
    
    [searchFeedDataSource setFeedData:feedData forCustomFeedCell:cell];
    
    BOOL assert = [((NSDictionary *)cell.feedData) isEqual:feedData];
    XCTAssertTrue(assert, @"");
}


@end
