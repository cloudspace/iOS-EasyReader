//
//  CSFeedItemCell.h
//  EasyReader
//
//  Created by Joseph Lorich on 3/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedItem.h"

/**
 * A feed item cell in the main easy reader collection view
 */
@interface EZRFeedItemCollectionViewCell : UICollectionViewCell


#pragma mark - IBOutlets

/// The feed item information view
@property (weak, nonatomic) IBOutlet UIView *info_view;

/// The feed item headline
@property (nonatomic, weak) IBOutlet UILabel *label_headline;

/// The feed item's source
@property (nonatomic, weak) IBOutlet UILabel *label_source;

/// The associated feed item image
@property (nonatomic, weak) IBOutlet UIImageView *imageView_background;

/// The associated feed item image
@property (nonatomic, weak) IBOutlet UIImageView *imageView_backgroundReflection;

/// The feed item summary
@property (weak, nonatomic) IBOutlet UILabel *label_summary;


#pragma mark - Other Properties

/// The feed item this cell is based on.  When set it will update all outlets appropriately
@property (nonatomic, weak) FeedItem *feedItem;


@end
