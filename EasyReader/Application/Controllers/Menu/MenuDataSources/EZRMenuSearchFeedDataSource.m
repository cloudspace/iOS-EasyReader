//
//  CSMenuSearchFeedDataSource.m
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRMenuSearchFeedDataSource.h"
#import "NSSet+CSSortingAdditions.h"
#import "UIColor+EZRSharedColorAdditions.h"

#import "EZRSearchFeedCell.h"
#import "EZRMenuAddFeedCell.h"

@interface EZRMenuSearchFeedDataSource ()

/// The menu table view
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end


@implementation EZRMenuSearchFeedDataSource
{
    /// The sorted array of feed data
    NSArray *sortedFeedData;
}

#pragma mark - Public methods

- (void)setFeedData:(NSDictionary *)feedData
{
    NSSet *feedSet = [NSSet setWithArray:feedData[@"feeds"]];
    
    sortedFeedData = [feedSet sortedArrayByAttributes:@"name", nil];
    [self.tableView reloadData];
}


#pragma mark - Private methods

/**
 * Determines the number of rows in each section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sortedFeedData count];
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
    return 44;
}

/**
 * Generates a cell for a given index path
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[sortedFeedData objectAtIndex:indexPath.row] objectForKey:@"feed_items"]) {
        EZRSearchFeedCell *cell = (EZRSearchFeedCell *)[tableView dequeueReusableCellWithIdentifier:@"SearchFeedCell"];
        
        cell.feedData = sortedFeedData[indexPath.row];
        
        return cell;
    } else {
        EZRMenuAddFeedCell *cell = (EZRMenuAddFeedCell *)[tableView dequeueReusableCellWithIdentifier:@"CustomFeedCell"];
        
        cell.feedData = sortedFeedData[indexPath.row];
        
        return cell;
    }
}

@end
