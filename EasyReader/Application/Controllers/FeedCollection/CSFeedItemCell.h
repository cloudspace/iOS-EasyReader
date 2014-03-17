//
//  CSFeedItemCell.h
//  EasyReader
//
//  Created by Joseph Lorich on 3/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSFeedItemCell : UICollectionViewCell


/// The feed item headline
@property (nonatomic, weak) IBOutlet UILabel *label_headline;

/// The feed item's source
@property (nonatomic, weak) IBOutlet UILabel *label_source;

/// The associated feed item image
@property (nonatomic, weak) IBOutlet UIImageView *imageView_background;

/// The feed item summary
@property (nonatomic, weak) IBOutlet UITextView *textView_summary;


@end
