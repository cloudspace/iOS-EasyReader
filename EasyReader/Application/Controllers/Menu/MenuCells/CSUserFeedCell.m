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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 * Sets the fields in the cell
 *
 * @param feed The Feed object associated to the user
 */
- (void)setFeed:(Feed *)feed
{
    // Set the label text
    self.label_name.text = feed.name;
    
    // Show feed icons
    [self.imageView_icon setHidden:NO];
    [self.imageView setImageWithURL:[NSURL URLWithString:feed.icon] placeholderImage:nil];
    
}

@end
