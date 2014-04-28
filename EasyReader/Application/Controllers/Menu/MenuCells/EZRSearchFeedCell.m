//
//  CSSearchFeedCell.m
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRSearchFeedCell.h"
#import "Feed.h"
#import "User.h"

@implementation EZRSearchFeedCell

/**
 * Sets the fields in the cell
 *
 * @param feedData The NSDicitionary of the searched feed
 */
- (void)setFeedData:(NSDictionary *)feedData
{
    _feedData = feedData;
    self.imageView_icon.image = [UIImage imageNamed:@"icon_plus"];
    self.label_name.text = [feedData objectForKey:@"name"];
}

@end
