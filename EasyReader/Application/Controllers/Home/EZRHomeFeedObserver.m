//
//  CSHomeFeedObserver.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRHomeFeedObserver.h"
#import "EZRHomeViewController.h"
#import "EZRHomeCollectionViewDataSource.h"
#import "Feed.h"
#import "User.h"

#import <Block-KVO/NSObject+MTKObserving.h>

@implementation EZRHomeFeedObserver
{
    /// The home view controller
    EZRHomeViewController  *controller;
    
    ///
    NSMutableSet *_feedItems;
    
    /// The current user
    User *_currentUser;
    
    /// The collection view data source
    EZRHomeCollectionViewDataSource *_collectionViewDataSource;

}

- (id)initWithController:(EZRHomeViewController *)homeController
               feedItems:(NSMutableSet *)feedItems
collectionViewDataSource:(EZRHomeCollectionViewDataSource *)collectionViewDataSource
             currentUser:(User *)currentUser

{
    self = [super init];
    
    if (self)
    {
        controller        = homeController;
        _feedItems        = feedItems;
        _currentUser      = currentUser;
        _collectionViewDataSource = collectionViewDataSource;
    }
    
    return self;
}

/**
 * Assigns observers for feedsItems when feeds array on current user changes
 */
- (void (^)(EZRHomeViewController *, NSSet *, NSSet *)) feedsDidChange
{
    return ^void(__weak EZRHomeViewController *_controller, NSSet *old, NSSet *new) {
        NSMutableArray *addedFeeds = [[new allObjects] mutableCopy];
        NSMutableArray *removedFeeds = [[old allObjects] mutableCopy];
        
        [addedFeeds removeObjectsInArray:[old allObjects]];
        [removedFeeds removeObjectsInArray:[new allObjects]];
        
        // Stop observing old feeds
        for ( Feed *feed in removedFeeds ){
            [feed removeAllObservations];
        }
        
        // Observe added feeds
        for ( Feed *feed in addedFeeds ){
            [feed observeRelationship:@"feedItems"
                          changeBlock:[self feedItemsDidChange]
                       insertionBlock:nil
                         removalBlock:nil
                     replacementBlock:nil];
        }
        
        //redraw the collection with the changes to the new feed items
        
        [_feedItems removeAllObjects];
        [_feedItems addObjectsFromArray:[_currentUser.feedItems sortedArrayUsingDescriptors:nil]];
        
        
        _collectionViewDataSource.feedItems = _feedItems;
        
        [controller.collectionView_feedItems reloadData];

        controller.pageControl_itemIndicator.numberOfPages = [_feedItems count] < 6 ? [_feedItems count] : 5;
        
        
        if(controller.currentFeedItem){
            [controller scrollToCurrentFeedItem];
            //            _pageControl_itemIndicator setPageControllerPageAtIndex:<#(NSInteger)#>
            //            [_pageControl_itemIndicator setPageControllerPageAtIndex:[_feedCollectionViewDataSource.sortedFeedItems indexOfObject:_currentFeedItem]
            //                                                       forCollection:_feedItems];
        } else {
            //            [_pageControl_itemIndicator setPageControllerPageAtIndex:0 forCollection:_feedItems];
        }
    };
}

/**
 * Called when feedItems array on observed feeds change, shows new item button on page control
 */
- (void (^)(Feed *, NSSet *, NSSet *))feedItemsDidChange
{
    return ^void(Feed *feed, NSSet *old, NSSet *new) {
        EZRHomeCollectionViewDataSource *dataSource = (EZRHomeCollectionViewDataSource *)controller.collectionView_feedItems.dataSource;
        
        controller.feedItems = [dataSource.feedItems mutableCopy];
        
        if(!new) {
            NSLog(@"There are no feed items here");
        } else {
            NSMutableArray *addedFeedItems = [[new allObjects] mutableCopy];
            NSMutableArray *removedFeedItems = [[old allObjects] mutableCopy];
            
            [addedFeedItems removeObjectsInArray:[old allObjects]];
            [removedFeedItems removeObjectsInArray:[new allObjects]];
            
            for( FeedItem *item in removedFeedItems ){
                [controller.feedItems removeObject:item];
            }
            
            for( FeedItem *item in addedFeedItems ){
                [controller.feedItems addObject:item];
            }
            
            if (_currentPageIndex == 0)
            {
                [controller prefetchImagesNearIndex:0 count:5];
            }
            
            dataSource.feedItems = controller.feedItems;
            [controller.collectionView_feedItems reloadData];
            if (controller.currentFeedItem) [controller scrollToCurrentFeedItem];
            
            //            [_pageControl_itemIndicator.button_newItem setHidden:NO];
        }
    };
}


@end
