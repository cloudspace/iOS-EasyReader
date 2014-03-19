//
//  FeedCollectionViewDataSource.h
//  EasyReader
//
//  Created by Joseph Lorich on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FeedItem, CSFeedItemCell;

typedef void (^configureFeedItemCell)(CSFeedItemCell *, FeedItem *);

/**
 * The data source for the FeedCollectionView's UICollectionView
 */
@interface CSFeedItemCollectionViewDataSource : NSObject <UICollectionViewDataSource>

/**
 * Initializes the data source with a reusable cell identifier
 *
 * @param The identifier to use to dequeue reusable cells for the collection view
 * @param configureFeedItemCell A block which will configure the cell based on the given FeedItem
 */
- (id)initWithFeedItems:(NSArray *)feedItems
 reusableCellIdentifier:(NSString *)reusableCellIdentifier
         configureBlock:(configureFeedItemCell)configureFeedItemCell;

/// The FeedItems for this data source
@property (nonatomic, strong) NSMutableSet *feedItems;

@end
