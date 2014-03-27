//
//  CSSearchFeedCell.m
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSSearchFeedCell.h"
#import "Feed.h"
#import "User.h"

@implementation CSSearchFeedCell

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
 * @param feedData The NSDicitionary of the searched feed
 */
- (void)setFeedData:(NSDictionary *)feedData
{
    _feedData = feedData;
    
    self.label_name.text = [feedData objectForKey:@"name"];
}

@end
