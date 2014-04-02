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
 * @param reusableCellIdentifier The reusable cell identifier to dequeue a cell with
 */
- (instancetype)initWithReusableCellIdentifier:(NSString *)reusableCellIdentifier;

/// The FeedItems for this data source
@property (nonatomic, strong) NSSet *feedItems;

/// The FeedItems sorted by createdAt time
@property (nonatomic, readonly) NSArray *sortedFeedItems;


@end
