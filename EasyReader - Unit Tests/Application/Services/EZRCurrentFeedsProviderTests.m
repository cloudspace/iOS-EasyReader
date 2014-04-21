//
//  EZRCurrentFeedsProviderTests.m
//  EasyReader
//
//  Created by Alfredo Uribe on 4/21/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Block-KVO/MTKObserving.h>

#import "EZRBaseServiceTests.h"
#import "EZRCurrentFeedsProvider.h"

// Models
#import "FeedItem.h"
#import "Feed.h"
#import "User.h"

// Categories
#import "NSSet+CSSortingAdditions.h"

@interface EZRCurrentFeedsProvider (Test)

+ (void)setShared:(EZRCurrentFeedsProvider *)shared;

- (void)selectedFeedDidChange:(NSNotification *)notification;

- (void)userFeedsDidChange:(User *)currentUser oldFeeds:(NSSet *)oldFeeds newFeeds:(NSSet *)newFeeds;

- (void (^)(Feed *, NSSet *, NSSet *))feedItemsDidChange;

- (void)observeFeedItemsForFeeds:(NSArray *)feeds;

@end

@interface EZRCurrentFeedsProviderTests : EZRBaseServiceTests
{
    id testService;
    id partialMockService;
}
@end

@implementation EZRCurrentFeedsProviderTests

- (void)setUp
{
    [super setUp];
    testService = [[EZRCurrentFeedsProvider alloc] init];
    partialMockService = [OCMockObject partialMockForObject:[EZRCurrentFeedsProvider shared]];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSharedWithNoSharedInstanceSet
{
    XCTAssertTrue([[EZRCurrentFeedsProvider shared] isKindOfClass:[EZRCurrentFeedsProvider class]], @"");
}

- (void)testSharedWithSetSharedInstance
{
    testService = [EZRCurrentFeedsProvider shared];
    XCTAssertTrue([EZRCurrentFeedsProvider shared] == testService, @"");
}

- (void)testSetShared
{
    testService = [[EZRCurrentFeedsProvider alloc] init];
    [EZRCurrentFeedsProvider setShared:testService];
    XCTAssertTrue([EZRCurrentFeedsProvider shared] == testService, @"");
}

- (void)testSelectedFeedDidChangeWithFeed
{
    id mockNotification = [OCMockObject mockForClass:[NSNotification class]];
    
    [[partialMockService expect] willChangeValueForKey:@"visibleFeedItems"];
    
    Feed *feed = [Feed MR_createEntity];
    [[[mockNotification expect] andReturn:feed] object];
    
    FeedItem *feedItem1 = [FeedItem MR_createEntity];
    FeedItem *feedItem2 = [FeedItem MR_createEntity];
    NSSet *feedItemSet = [NSSet setWithArray:@[feedItem1, feedItem2]];
    
    [feed addFeedItems:feedItemSet];
    
    [[partialMockService expect] didChangeValueForKey:@"visibleFeedItems"];

    [partialMockService selectedFeedDidChange:mockNotification];
    
    if( [[partialMockService visibleFeedItems] isEqualToArray:
         [feedItemSet sortedArrayByAttributes:@[@"createdAt"] ascending:YES]] )
    {
        [partialMockService verify];
    } else {
        XCTAssertTrue(NO, @"");
    }
}

- (void)testSelectedFeedDidChangeNoFeed
{
    id mockNotification = [OCMockObject mockForClass:[NSNotification class]];
    
    [[partialMockService expect] willChangeValueForKey:@"visibleFeedItems"];
    
    [[[mockNotification expect] andReturn:nil] object];
    
    [[partialMockService expect] didChangeValueForKey:@"visibleFeedItems"];
    
    [partialMockService selectedFeedDidChange:mockNotification];
    
    if( [[partialMockService visibleFeedItems] isEqualToArray:[partialMockService feedItems]] ){
        [partialMockService verify];
    } else {
        XCTAssertTrue(NO, @"");
    }
}

//- (void)testUserFeedDidChangeWithFeed
//{
//    User *currentUser = [User current];
//    
//    Feed *f =[Feed MR_createEntity];
//    Feed *f2 =[Feed MR_createEntity];
//    
//    id oldFeed = [OCMockObject partialMockForObject:f];
//    id newFeed = [OCMockObject partialMockForObject:f2];
//    
//    NSSet *oldFeeds = [NSSet setWithArray:@[oldFeed]];
//    NSSet *newFeeds = [NSSet setWithArray:@[newFeed]];
//    
//    [[oldFeed expect] removeAllObservations];
//    [[newFeed expect] observeRelationship:@"feedItems"
//                              changeBlock:[OCMArg any]
//                           insertionBlock:[OCMArg any]
//                             removalBlock:[OCMArg any]
//                         replacementBlock:[OCMArg any]];
//    
//    [[partialMockService expect] willChangeValueForKey:@"feeds"];
//    [[partialMockService expect] willChangeValueForKey:@"feedItems"];
//    [[partialMockService expect] willChangeValueForKey:@"visibleFeedItems"];
//
//    [[partialMockService expect] observeFeedItemsForFeeds:[[newFeeds allObjects] mutableCopy]];
//    
//    [[partialMockService expect] didChangeValueForKey:@"feeds"];
//    [[partialMockService expect] didChangeValueForKey:@"feedItems"];
//    [[partialMockService expect] didChangeValueForKey:@"visibleFeedItems"];
//    
//    [partialMockService userFeedsDidChange:currentUser
//                                  oldFeeds:oldFeeds
//                                  newFeeds:newFeeds];
//    
//    [partialMockService verify];
//    
//}

@end
