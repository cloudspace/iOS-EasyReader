//
//  CSFeedItemView.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/5/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTLabel;
@interface CSFeedItemView : UITableViewCell

#pragma mark - IBOutlet Properties
@property (nonatomic, retain) MTLabel     *label_title;
@property (nonatomic, retain) MTLabel     *label_description;
@property (nonatomic, retain) UIImageView *imageView_image;

@end
