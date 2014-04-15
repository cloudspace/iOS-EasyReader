//
//  CSArrayTableViewDataSource.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/14/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSArrayTableViewDataSource.h"

@implementation CSArrayTableViewDataSource


#pragma mark - Data Source Methods
/**
 * Determines the number of rows in each section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.source count];
}

/**
 * Generates a cell for a given index path
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue a styled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.reusableCellIdentifier];
    
    id item = self.source[indexPath.row];
    
    self.configureCell(cell, item);
    
    return cell;
}

/**
 * Commits each editing action
 */
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        Feed *toDelete = [sortedFeeds objectAtIndex:indexPath.row];
//        
//        [[User current] removeFeedsObject:toDelete];
//        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//        [self.tableView reloadData];
//    }
//}

@end
