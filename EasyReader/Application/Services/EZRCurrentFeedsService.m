//
//  EZRCurrentFeedsService.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/15/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRCurrentFeedsService.h"

#import "NSSet+CSSortingAdditions.h"

#import "User.h"
#import "Feed.h"
#import "FeedItem.h"

#import <Block-KVO/MTKObserving.h>


static dispatch_once_t pred;
static EZRCurrentFeedsService *sharedInstance;


@implementation EZRCurrentFeedsService
{
    /// The current user
    User *currentUser;
    
    /// The currently selected feed (if any)
    Feed *currentFeed;
}

+ (EZRCurrentFeedsService *) shared
{
    dispatch_once(&pred, ^{
        if (sharedInstance != nil) {
            return;
        }
        
        sharedInstance = [[EZRCurrentFeedsService alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        currentUser = [User current];
        _feeds = [currentUser.feeds sortedArrayByAttributes:@"name", nil];
        _feedItems = [currentUser.feedItems sortedArrayByAttributes:@"createdAt", nil];
        _visibleFeedItems = _feedItems;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(selectedFeedDidChange:)
                                                     name:@"kEZRFeedSelected"
                                                   object:nil];
        
        [self observeObject:currentUser property:@"feeds" withSelector:@selector(userFeedsDidChange:oldFeeds:newFeeds:)];
    }
    
    return self;
}

- (void)selectedFeedDidChange:(NSNotification *)notification
{
    Feed *feed = notification.object;
    
    [self willChangeValueForKey:@"visibleFeedItems"];
    
    if (feed) {
        _visibleFeedItems = [feed.feedItems sortedArrayByAttributes:@"createdAt", nil];
    } else {
        _visibleFeedItems = _feedItems;
    }
    
    [self didChangeValueForKey:@"visibleFeedItems"];
}


- (void) userFeedsDidChange:(User *)currentUser oldFeeds:(NSSet *)oldFeeds newFeeds:(NSSet *)newFeeds {
    [self willChangeValueForKey:@"feeds"];
    [self willChangeValueForKey:@"feedItems"];
    
    NSMutableSet *feedItems = [NSMutableSet setWithArray:self.feedItems];
    
    NSMutableArray *addedFeeds = [[newFeeds allObjects] mutableCopy];
    NSMutableArray *removedFeeds = [[oldFeeds allObjects] mutableCopy];
    
    [addedFeeds removeObjectsInArray:[oldFeeds allObjects]];
    [removedFeeds removeObjectsInArray:[newFeeds allObjects]];
    
    // Stop observing old feeds
    for ( Feed *feed in removedFeeds ){
        [feed removeAllObservations];
    }
    
    for (FeedItem *item in _feedItems) {
        if ([removedFeeds containsObject:item.feed]) {
            [feedItems removeObject:item];
        }
    }
    
    // Observe added feeds
    for ( Feed *feed in addedFeeds ) {
        [feed observeRelationship:@"feedItems"
                      changeBlock:[self feedItemsDidChange]
                   insertionBlock:nil
                     removalBlock:nil
                 replacementBlock:nil];
        
        [feedItems addObjectsFromArray:[feed.feedItems sortedArrayUsingDescriptors:nil]];
    }
    
    _feedItems = [feedItems sortedArrayByAttributes:@"createdAt", nil];
    
    [self didChangeValueForKey:@"feeds"];
    [self didChangeValueForKey:@"feedItems"];
}


/**
 * Called when feedItems array on observed feeds change, shows new item button on page control
 */
- (void (^)(Feed *, NSSet *, NSSet *))feedItemsDidChange
{
    return ^void(Feed *feed, NSSet *old, NSSet *new) {
        [self willChangeValueForKey:@"feedItems"];
        _feedItems = [currentUser.feedItems sortedArrayByAttributes:@"createdAt", nil];
        [self didChangeValueForKey:@"feedItems"];
    };
}


@end
