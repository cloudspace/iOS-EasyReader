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
 * Add the feed to the user and save it in the database
 */
- (IBAction)addFeedToUser:(id)sender {
    // Create a new Feed object and associated FeedItem objects
    Feed *newFeed = [Feed createOrUpdateFirstFromAPIData:self.feed];
    
    // Add the feed to the currentUsers feeds
    User *currentUser = [User current];
    NSMutableSet *mutableSet = [NSMutableSet setWithSet:currentUser.feeds];
    [mutableSet addObject:newFeed];
    currentUser.feeds = mutableSet;
    
    // Save the feed and feed items in the database
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

/**
 * Sets the fields in the cell
 *
 * @param feedData The NSDicitionary of the searched feed
 */
- (void)setFeedData:(NSDictionary *)feedData
{
    self.label_name.text = [feedData objectForKey:@"name"];
}

@end
