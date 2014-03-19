//
//  CSFeedItemCollectionView.h
//  EasyReader
//
//  Created by Michael Beattie on 3/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"

@interface CSFeedItemCollectionView : UICollectionView

@property (nonatomic,readonly) FeedItem *currentFeedItem;

@end
