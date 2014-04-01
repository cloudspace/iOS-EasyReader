//
//  CSMenuLeftViewControllerTests.m
//  EasyReader
//
//  Created by Alfredo Uribe on 3/28/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "EZRBaseControllerTests.h"
#import "CSMenuLeftViewController.h"
#import "CSMenuUserFeedDataSource.h"
#import "CSMenuSearchFeedDataSource.h"

// Models
#import "User.h"
#import "Feed.h"

typedef void (^ObserverBlock)(__weak CSMenuLeftViewController *self, NSSet *old, NSSet *new);

@interface CSMenuLeftViewController (Test)

- (void)setUpDataSources;
- (void)applyMenuStyles;
- (void)updateUserFeedDataSource;
- (ObserverBlock) feedsDidChange;
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) CSMenuUserFeedDataSource *userFeedDataSource;
@property (strong, nonatomic) CSMenuSearchFeedDataSource *searchFeedDataSource;

@end


@interface CSMenuLeftViewControllerTests : EZRBaseControllerTests
{
    CSMenuLeftViewController *controller;
}
@end


@implementation CSMenuLeftViewControllerTests

- (void)setUp
{
    [super setUp];
    controller = [[CSMenuLeftViewController alloc] init];
    controller.tableView_feeds = [[UITableView alloc] init];
//    controller.textField_searchInput = [[UITextField alloc] init];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSetUpDataSources
{
    [controller setUpDataSources];
    XCTAssert([controller userFeedDataSource] != nil && [controller userFeedDataSource] != nil, @"");
}

- (void)testUpdateSearchFeedDataSource
{
    [controller searchFeedDataSource];
    XCTAssert( [[controller tableView_feeds] dataSource] == [controller searchFeedDataSource], @"");
}

- (void)testUpdateUserFeedDataSource
{
    [controller searchFeedDataSource];
    XCTAssert( [[controller tableView_feeds] dataSource] == [controller userFeedDataSource] &&
              [[[controller textField_searchInput] text] isEqualToString:@""], @"");
}

- (void)testViewDidLoadProperties
{
    [User current];
    [controller viewDidLoad];
    
    XCTAssert([controller currentUser] == [User current] &&
              [controller feeds] != nil &&
              [[controller tableView_feeds] delegate] == controller &&
              [[controller userFeedDataSource] feeds] == [controller feeds],
              @"");
}

- (void)testViewDidLoadMethods
{
    id mockedController = [OCMockObject partialMockForObject:controller];
    
    [[mockedController expect] setUpDataSources];
    [[mockedController expect] applyMenuStyles];
    [[mockedController expect] updateUserFeedDataSource];
    
    [mockedController viewDidLoad];
    [mockedController verify];
}

- (void)testFeedsDidChange
{
    id mockedController = [OCMockObject partialMockForObject:controller];
    
    [mockedController viewDidLoad];
    [[User current] addFeedsObject:[Feed MR_createEntity]];
    
    XCTAssert( [[mockedController feeds] count] == 1, @"");
}

- (void)testNumberOfSectionsInTableView
{
    XCTAssert( [controller numberOfSectionsInTableView:[controller tableView_feeds]] == 1, @"");
}

- (void)testDidSelectRowAtIndexPath
{
    NSIndexPath *indexPath = [[NSIndexPath alloc] init];
    id mockedController = [OCMockObject partialMockForObject:controller];
    id mockedTable = [OCMockObject partialMockForObject:[[UITableView alloc] init]];
    
    [controller setTableView_feeds: mockedTable];
    
    [[mockedTable expect] deselectRowAtIndexPath:indexPath animated:YES];
    [mockedController tableView:mockedTable didSelectRowAtIndexPath:indexPath];
    
    [mockedTable verify];
}

@end
