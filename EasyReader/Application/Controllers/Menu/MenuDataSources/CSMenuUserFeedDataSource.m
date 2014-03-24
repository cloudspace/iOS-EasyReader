//
//  CSMenuUserFeedDataSource.m
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSMenuUserFeedDataSource.h"

#import "UIImageView+AFNetworking.h"

#import "UIColor+EZRSharedColorAdditions.h"

#import "CSUserFeedCell.h"

#import "Feed.h"
#import "FeedItem.h"

@implementation CSMenuUserFeedDataSource

/**
 * Sets each instance variable to the values in the given parameters
 */
- (id)init
{
    self = [super init];
    
    if (self) {
        _feeds = [[NSMutableSet alloc] init];
    }
    
    return self;
}

/**
 * Sets the feeds to those in the database
 */
- (void)updateWithFeeds:(NSMutableSet *)feeds
{
    self.feeds = feeds;
}


#pragma mark - Count Methods
/**
 * Determines the number of rows in each section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_feeds count];
}


#pragma mark - Size Methods
/**
 * Height of the header in each section
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

/**
 * Height of all the cells
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


#pragma mark - Cell View
/**
 * Generates a cell for a given index path
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue a styled cell
    CSUserFeedCell *cell = (CSUserFeedCell *)[tableView dequeueReusableCellWithIdentifier:@"UserFeedCell"];
    
    Feed *feed = [self.feeds allObjects][indexPath.row];
    cell.feed = feed;
    
    // Set the label text
    cell.label_name.text = feed.name;
    cell.label_name.textColor = [UIColor whiteColor];
    
    // Show feed icons
    [cell.imageView_icon setHidden:NO];
    [cell.imageView setImageWithURL:[NSURL URLWithString:feed.icon] placeholderImage:nil];

    UIView *selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor: [UIColor EZR_charcoal]];
    cell.selectedBackgroundView = selectedBackgroundView;
    return cell;
}

/**
 * Commits each editing action
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Feed *toDelete = [self.feeds allObjects][indexPath.row];
        
        [toDelete deleteEntity];
        
        [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    }
}

/**
 * Determines the editing style for each row
 */
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == [_feeds count] ) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

@end
