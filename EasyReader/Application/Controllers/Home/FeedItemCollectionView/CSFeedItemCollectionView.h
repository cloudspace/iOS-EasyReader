//
//  CSFeedItemCollectionView.h
//  EasyReader
//
//  Created by Michael Beattie on 3/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"

/**
 * A collection view built to hold feed items
 */
@interface CSFeedItemCollectionView : UICollectionView

/**
 * The feed item that is currently focused
 */
@property (nonatomic, readonly) FeedItem *currentFeedItem;


@end
