//
//  EZRCustomFeedCell.m
//  EasyReader
//
//  Created by Michael Beattie on 3/24/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRCustomFeedCell.h"
#import "Feed.h"
#import "User.h"

@implementation EZRCustomFeedCell

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
 * Attempts to creat a new feed and save it to the user
 */
- (IBAction)createFeed:(id)sender {
    [Feed createFeedWithUrl:self.label_url.text
                    success:^(id responseData, NSInteger httpStatus){
                        if (httpStatus == 201) {
                            NSLog(@"201");
                        }
                        if (httpStatus == 200) {
                            NSLog(@"200");
                        }
                        
                        NSDictionary *feeds = [responseData objectForKey:@"feeds"];
                        NSLog(@"%@",responseData);
                        for ( NSDictionary *feed in feeds){
                            // Create a new Feed object and associated FeedItem objects if they exist
                            Feed *newFeed = [Feed createOrUpdateFirstFromAPIData:feed];
                            
                            // Add the feed to the currentUsers feeds
                            User *currentUser = [User current];
                            NSMutableSet *mutableSet = [NSMutableSet setWithSet:currentUser.feeds];
                            [mutableSet addObject:newFeed];
                            currentUser.feeds = mutableSet;
                            
                            // Save the feed and feed items in the database
                            [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
                        }
                    }
                    failure:^(id responseData, NSInteger httpStatus, NSError *error){
                        if (httpStatus == 422) {
                            // Notify user that this is not a real rss feed
                        }
                    }];
}

@end
