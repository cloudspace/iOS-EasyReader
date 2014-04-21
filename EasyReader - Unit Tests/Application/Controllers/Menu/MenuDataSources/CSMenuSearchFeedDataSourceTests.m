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
#import "EZRMenuFeedCell.h"

// Models
#import "Feed.h"
#import "FeedItem.h"
#import "User.h"

@interface EZRMenuSearchFeedDataSource(Test)

- (void)sortFeeds;
- (void)setFeedData:(NSDictionary *)feedData forSearchFeedCell:(EZRSearchFeedCell *)cell;
- (void)setFeedData:(NSDictionary *)feedData forCustomFeedCell:(EZRMenuFeedCell *)cell;

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

@end
