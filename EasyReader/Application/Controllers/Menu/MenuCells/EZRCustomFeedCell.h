//
//  EZRCustomFeedCell.h
//  EasyReader
//
//  Created by Michael Beattie on 3/24/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * A UITableViewCell for custom feed data
 */
@interface EZRCustomFeedCell : UITableViewCell

#pragma mark - IBOutlets

/// The custom feed url
@property (weak, nonatomic) IBOutlet UILabel *label_url;

/// Button to add the custom feed
@property (weak, nonatomic) IBOutlet UIButton *button_addFeed;

/// The create feed action
- (IBAction)button_addFeed_touchUpInside:(id)sender;

#pragma mark - Other Properties

/// The NSDictionary of the feed this cell is based on
@property (nonatomic, weak) NSDictionary *feedData;

@end
