//
//  CSMenuUserFeedDataSource.m
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRMenuUserFeedDataSource.h"

#import "UIColor+EZRSharedColorAdditions.h"

#import "EZRMenuFeedCell.h"

#import "Feed.h"
#import "FeedItem.h"
#import "User.h"

#import "EZRMenuViewController.h"

#import "EZRCurrentUserProxy.h"
#import <Block-KVO/MTKObserving.h>


#import "NSSet+CSSortingAdditions.h"

@interface EZRMenuUserFeedDataSource ()

/// The menu table view
@property (nonatomic, weak) IBOutlet UITableView *tableView;

/// A proxy object containing the current user
@property (nonatomic, weak) IBOutlet EZRCurrentUserProxy *userProxy;


@end


@implementation EZRMenuUserFeedDataSource
{
    /// The sorted array of feeds
    NSArray *sortedFeeds;
}

/**
 * Sets up observers on awaken
 */
- (void) awakeFromNib
{
    [self observeRelationship:@keypath(self.userProxy.user.feeds) changeBlock:^(__weak EZRMenuUserFeedDataSource *self, NSSet *feeds) {
        sortedFeeds = [feeds sortedArrayByAttributes:@"name", nil];
        [self.tableView reloadData];
    }];
}



#pragma mark - Data Source Methods
/**
 * Determines the number of rows in each section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sortedFeeds count];
}

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
    return 35;
}

/**
 * Generates a cell for a given index path
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue a styled cell
    EZRMenuFeedCell *cell = (EZRMenuFeedCell *)[tableView dequeueReusableCellWithIdentifier:@"UserFeedCell"];
    
    // Get the feed
    Feed *feed = [sortedFeeds objectAtIndex:indexPath.row];
    
    cell.feed = feed;
    

    return cell;
}

///**
// * Set the feed for a user cell
// */
//- (void)setFeed:(Feed *)feed forUserFeedCell:(EZRMenuFeedCell *)cell
//{
//    cell.feed = feed;
//    
//    [self setSelectedBackgroundForCell:cell];
//}
//
///**
// * Set the selectedBackgroundView for a cell
// */
//- (void)setSelectedBackgroundForCell:(UITableViewCell *)cell
//{
//    UIView *selectedBackgroundView = [[UIView alloc] init];
//    [selectedBackgroundView setBackgroundColor: [UIColor EZR_charcoal]];
//    cell.selectedBackgroundView = selectedBackgroundView;
//}

/**
 * Commits each editing action
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Feed *toDelete = [sortedFeeds objectAtIndex:indexPath.row];
        
        [[User current] removeFeedsObject:toDelete];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        [self.tableView reloadData];
    }
}

/**
 * Determines the editing style for each row
 */
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row == [sortedFeeds count] ) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

@end