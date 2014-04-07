//
//  CSUserFeedCellTableViewCell.m
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "UIImageView+AFNetworking.h"

#import "CSUserFeedCell.h"
#import "Feed.h"

@implementation CSUserFeedCell

/**
 * Sets the fields in the cell
 *
 * @param feed The Feed object associated to the user
 */
- (void)setFeed:(Feed *)feed
{
    _feed = feed;
    
    self.label_name.text = feed.name;

    [self.imageView_icon setHidden:NO];
    [self.imageView setImageWithURL:[NSURL URLWithString:feed.icon] placeholderImage:nil];
    
}

@end
