//
//  CSMenuUserFeedDataSource.m
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSMenuUserFeedDataSource.h"

#import "UIColor+EZRSharedColorAdditions.h"

#import "CSUserFeedCell.h"

#import "Feed.h"
#import "FeedItem.h"
#import "User.h"

@implementation CSMenuUserFeedDataSource
{
    /// Feeds used to populate the menu table
    NSSet *_feeds;
    
    /// Sorted feeds
    NSArray *_sortedFeeds;
    
    /// The current user
    User *_currentUser;

}


#pragma mark - Public methods

- (void)setFeeds:(NSMutableSet *)feeds
{
    _feeds = feeds;
    _sortedFeeds = [self sortFeeds:_feeds];
}

#pragma mark - Private Methods

/**
 * Sets each instance variable to the values in the given parameters
 */
- (id)init
{
    self = [super init];
    
    if (self) {
        _feeds = [[NSMutableSet alloc] init];
        _sortedFeeds = [[NSArray alloc] init];
        _currentUser = [User current];
    }
    
    return self;
}


/**
 * Sorts a list of feeds alphabetically
 *
 * @param the feeds to sort
 */
- (NSArray *)sortFeeds:(NSSet *)feeds
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    return [[NSArray arrayWithArray:[feeds allObjects]] sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
}


#pragma mark - Count Methods
/**
 * Determines the number of rows in each section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_sortedFeeds count];
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
 * Dequeus and configures a cell for a given index path
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CSUserFeedCell *cell = (CSUserFeedCell *)[tableView dequeueReusableCellWithIdentifier:@"UserFeedCell"];
    
    Feed *feed = _sortedFeeds[indexPath.row];
    
    cell.feed = feed;
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor: [UIColor EZR_charcoal]];
    cell.selectedBackgroundView = selectedBackgroundView;
    
    return cell;
}

/**
 * Set the feed for a user cell
 */
- (void)setFeed:(Feed *)feed forUserFeedCell:(CSUserFeedCell *)cell
{
    cell.feed = feed;
    
    [self setSelectedBackgroundForCell:cell];
    
}

/**
 * Set the selectedBackgroundView for a cell
 */
- (void)setSelectedBackgroundForCell:(UITableViewCell *)cell
{
    UIView *selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor: [UIColor EZR_charcoal]];
    cell.selectedBackgroundView = selectedBackgroundView;
}

/**
 * Commits each editing action
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Feed *toDelete = [_sortedFeeds objectAtIndex:indexPath.row];

        [_currentUser removeFeedsObject:toDelete];
    }
}

/**
 * Determines the editing style for each row
 */
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == [_sortedFeeds count] ) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

@end
