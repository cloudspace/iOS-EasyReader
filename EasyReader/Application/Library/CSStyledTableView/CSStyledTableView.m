//
//  CSStyledTableView.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSStyledTableView.h"
#import "CSStyledTableViewHeaderFooterView.h"
#import "CSStyledTableViewCell.h"
#import "CSStyledTableViewStyle.h"

@implementation CSStyledTableView


/**
 * Sets the table view style and updates the main table styles
 */
- (void)setTableViewStyle:(CSStyledTableViewStyle *)tableViewStyle
{
  _tableViewStyle = tableViewStyle;
  
  [self setBackgroundColor:[tableViewStyle tableBackgroundColor]];
  [self  setSeparatorColor:[tableViewStyle cellSeparatorColor]];
}

/**
 * The current table view style
 */
- (CSStyledTableViewStyle *)tableViewStyle
{
  return _tableViewStyle;
}


/**
 * Gets the default style or the current style if non is available
 */
- (CSStyledTableViewStyle *) tableViewStyleOrDefault
{
  if (!self.tableViewStyle)
  {
    self.tableViewStyle = [[CSStyledTableViewStyle alloc] init];
  }
  
  return self.tableViewStyle;
}

/**
 * Dequeues a reusable styled header/footer
 */
- (id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier
{
  // Generate a namespaced identifier
  identifier = [NSString stringWithFormat:@"CSStyledTableViewHeaderFooter-%@", identifier];
  
  // Dequeue a reusable view if available
  CSStyledTableViewHeaderFooterView * headerFooter = [super dequeueReusableHeaderFooterViewWithIdentifier:identifier];
  
  // Create a new view if none were available for dequeue
  if (headerFooter == nil)
  {
    headerFooter = [[CSStyledTableViewHeaderFooterView alloc] initWithTableViewStyle:[self tableViewStyleOrDefault] ReuseIdentifier:identifier];
  }
  
  headerFooter.tableViewStyle = [self tableViewStyleOrDefault];
  
  return headerFooter;
}

/**
 * Dequeues a reusable styled cell
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
  // Generate a namespaced identifier
  identifier = [NSString stringWithFormat:@"CSStyledTableViewCell-%@", identifier];
  
  // Dequeue a reusable view if available
  CSStyledTableViewCell * cell = [super dequeueReusableCellWithIdentifier:identifier];
  
  // Create a new view if none were available for dequeue
  if (cell == nil)
  {
    cell = [[CSStyledTableViewCell alloc] initWithTableViewStyle:[self tableViewStyleOrDefault] reuseIdentifier:identifier];
  }
  
  return cell;
}


@end
