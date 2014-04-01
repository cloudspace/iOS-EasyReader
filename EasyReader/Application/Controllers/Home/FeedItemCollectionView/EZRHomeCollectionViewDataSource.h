//
//  FeedCollectionViewDataSource.h
//  EasyReader
//
//  Created by Joseph Lorich on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FeedItem, EZRFeedItemCell;

typedef void (^configureFeedItemCell)(EZRFeedItemCell *, FeedItem *);

/**
 * The data source for the FeedCollectionView's UICollectionView
 */
@interface EZRHomeCollectionViewDataSource : NSObject <UICollectionViewDataSource>

/**
 * Initializes the data source with a reusable cell identifier
 *
 * @param feedItems The identifier to use to dequeue reusable cells for the collection view
 * @param reusableCellIdentifier The reusable cell identifier to dequeue a cell with
 * @param configureFeedItemCell A block which will configure the cell based on the given FeedItem
 */
- (id)initWithFeedItems:(NSSet *)feedItems reusableCellIdentifier:(NSString*)reusableCellIdentifier;

/// The FeedItems for this data source
@property (nonatomic, strong) NSSet *feedItems;

/// The FeedItems sorted by createdAt time
@property (nonatomic, readonly) NSArray *sortedFeedItems;


@end
