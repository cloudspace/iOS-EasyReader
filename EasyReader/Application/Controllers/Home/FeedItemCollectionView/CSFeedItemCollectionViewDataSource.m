//
//  FeedCollectionViewDataSource.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedItemCollectionViewDataSource.h"
#import "CSHomeViewController.h"
#import "FeedItem.h"
#import "EZRFeedItemCell.h"

@implementation CSFeedItemCollectionViewDataSource
{
    /// A block which will configure a cell based on a given FeedItem
    void (^_configureFeedItemCell)(EZRFeedItemCell *, FeedItem *feedItem);
    
    /// The identifier to use to dequeue reusable cells for the collection view
    NSString *_reusableCellIdentifier;
    
    // A sorted array of feed items
    NSArray *_sortedFeedItems;
}

- (void)setFeedItems:(NSMutableSet *)feedItems
{
    _feedItems = feedItems;
    _sortedFeedItems = [self sortFeedItems:feedItems];
}

/**
 * Sets each instance variable to the values in the given parameters
 */
- (id)initWithFeedItems:(NSSet *)feedItems
 reusableCellIdentifier:(NSString *)reusableCellIdentifier
         configureBlock:(void (^)(EZRFeedItemCell *, FeedItem *))configureFeedItemCell
{
    self = [super init];
    
    if (self)
    {
        [self setFeedItems:feedItems];
        
        _reusableCellIdentifier = reusableCellIdentifier;
        _configureFeedItemCell = configureFeedItemCell;
    }
    
    return self;
}

/**
 * Sorts a set of feed items by the updatedAt time
 *
 * @params feedItems The set of feed items to sort
 */
- (NSArray *)sortFeedItems:(NSSet *)feedItems
{
    NSArray *sortableArray = [NSArray arrayWithArray:[self.feedItems allObjects]];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updatedAt"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    return [sortableArray sortedArrayUsingDescriptors:sortDescriptors];
}

/**
 * Determines the number of sections in the collection view (in this case it's always 1)
 *
 * @param collectionView
 */
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


/**
 * Determines the number of items in the current collectionView section
 *
 * @param collectionView
 * @param section
 */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_sortedFeedItems count];
}

/**
 * Dequeues and configures a UICollectionViewCell for the given index path
 *
 * @param collectionView
 * @param indexPath
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EZRFeedItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_reusableCellIdentifier
                                                                     forIndexPath:indexPath];
    
    FeedItem *item = [_sortedFeedItems objectAtIndex:indexPath.row];
    _configureFeedItemCell(cell, item);
    
    [(CSHomeViewController*)collectionView.delegate setCollectionCellGoingTo:indexPath.row];
    
    return cell;
}

@end
