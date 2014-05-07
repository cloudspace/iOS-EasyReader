//
//  CSFeedItemCollectionView.h
//  EasyReader
//
//  Created by Michael Beattie on 3/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"

@class EZRFeedItemCollectionView;

@protocol EZRFeedItemCollectionViewDelegate<NSObject, UICollectionViewDelegate>

@optional

- (void)collectionView:(EZRFeedItemCollectionView *)collectionView didTapTitleOfItem:(FeedItem *)item;

@end


/**
 * A collection view built to hold feed items
 */
@interface EZRFeedItemCollectionView : UICollectionView

/// The feed item that is currently focused
@property (nonatomic, readonly) FeedItem *currentFeedItem;

/// The curent visible page index
@property (nonatomic, readonly) NSInteger currentPageIndex;


@end
