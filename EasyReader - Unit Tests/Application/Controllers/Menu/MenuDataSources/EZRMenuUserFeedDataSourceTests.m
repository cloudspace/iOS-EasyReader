//
//  EZRMenuUserFeedDataSource.m
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

@interface EZRMenuUserFeedDataSourceTests : EZRBaseControllerTests
{
    EZRMenuUserFeedDataSource *userFeedDataSource;
}
@end

@implementation EZRMenuUserFeedDataSourceTests

- (void)setUp
{
    [super setUp];
    userFeedDataSource = [[EZRMenuUserFeedDataSource alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

@end
