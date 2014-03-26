//
//  CSMenuSearchFeedDataSource.m
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSMenuSearchFeedDataSource.h"

#import "UIImageView+AFNetworking.h"

#import "UIColor+EZRSharedColorAdditions.h"

#import "CSSearchFeedCell.h"
#import "EZRCustomFeedCell.h"

#import "Feed.h"
#import "FeedItem.h"

@implementation CSMenuSearchFeedDataSource


/**
 * Sets each instance variable to the values in the given parameters
 */
- (id)init
{
    self = [super init];
    
    if (self) {
        _feeds = [[NSMutableSet alloc] init];
        _sortedFeeds = [[NSArray alloc] init];
    }
    
    return self;
}

/**
 * Sets the feeds to those returned by the search API or
 * The custom feed being created by the user
 */
- (void)updateWithFeeds:(NSMutableSet *)feeds
{
    self.feeds = feeds;
    [self sortFeeds];
}

/**
 * Sort the feeds alphabetically
 */
- (void)sortFeeds
{
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    self.sortedFeeds = [[NSArray arrayWithArray:[_feeds allObjects]] sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
}


#pragma mark - Count Methods
/**
 * Determines the number of rows in each section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sortedFeeds count];
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
    if ([[self.sortedFeeds objectAtIndex:indexPath.row] objectForKey:@"feed_items"]) {
        // Dequeue a styled cell
        CSSearchFeedCell *cell = (CSSearchFeedCell *)[tableView dequeueReusableCellWithIdentifier:@"SearchFeedCell"];
        
        // Get the feed
        NSDictionary *searchedFeed = [self.sortedFeeds objectAtIndex:indexPath.row];
        
        // Set the cell data
        [self setFeed:searchedFeed forSearchFeedCell:cell];

        return cell;
    }
    else{
        // Dequeue a styled cell
        EZRCustomFeedCell *cell = (EZRCustomFeedCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomFeedCell"];
        
        // Get the feed
        NSDictionary *customFeed = [self.sortedFeeds objectAtIndex:indexPath.row];

        // Set the cell data
        [self setFeed:customFeed forCustomFeedCell:cell];
        
        return cell;
    }
}

/**
 * Set the feed for a search cell
 */
- (void)setFeed:(NSDictionary *)feed forSearchFeedCell:(CSSearchFeedCell *)cell
{
    // Associate the feed to the cell
    cell.feed = feed;
    
    // Set the label text
    cell.label_name.text = [feed objectForKey:@"name"];
    
    [self setSelectedBackgroundForCell:cell];
}

/**
 * Set the feed for a custom cell
 */
- (void)setFeed:(NSDictionary *)feed forCustomFeedCell:(EZRCustomFeedCell *)cell
{
    NSString *customUrl = [feed objectForKey:@"url"];
    cell.label_url.text = customUrl;
    
    // Hide the add button unless the user types a valid url
    [cell.button_addFeed setHidden:YES];
    if([self isValidUrl:customUrl]){
        [cell.button_addFeed setHidden:NO];
    }
    
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
 * Check for a letter followed by a dot
 */
- (BOOL)isValidUrl:(NSString *)url
{
    NSError *error = NULL;
    NSString *pattern = @"[a-z][.]";
    NSString *string = url;
    NSRange range = NSMakeRange(0, string.length);
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:string options:NSMatchingReportCompletion range:range];
    
    if (matches.count > 0) {
        return TRUE;
    }
    return FALSE;
}

@end
