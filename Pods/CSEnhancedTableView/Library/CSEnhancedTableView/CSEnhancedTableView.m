//
//  CSEnhancedTableView.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSEnhancedTableView.h"
#import "CSEnhancedTableViewHeaderFooterView.h"
#import "CSEnhancedTableViewCell.h"
#import "CSEnhancedTableViewStyle.h"

@implementation CSEnhancedTableView


/**
 * Sets the table view style and updates the main table styles
 */
- (void)setTableViewStyle:(CSEnhancedTableViewStyle *)tableViewStyle
{
  _tableViewStyle = tableViewStyle;
  
  [self setBackgroundColor:[tableViewStyle tableBackgroundColor]];
  [self  setSeparatorColor:[tableViewStyle cellSeparatorColor]];
}

/**
 * The current table view style
 */
- (CSEnhancedTableViewStyle *)tableViewStyle
{
  return _tableViewStyle;
}


/**
 * Gets the default style or the current style if non is available
 */
- (CSEnhancedTableViewStyle *) tableViewStyleOrDefault
{
  if (!self.tableViewStyle)
  {
    self.tableViewStyle = [[CSEnhancedTableViewStyle alloc] init];
  }
  
  return self.tableViewStyle;
}

/**
 * Dequeues a reusable styled header/footer
 */
- (id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier
{
  // Generate a namespaced identifier
  identifier = [NSString stringWithFormat:@"CSEnhancedTableViewHeaderFooter-%@", identifier];
  
  // Dequeue a reusable view if available
  CSEnhancedTableViewHeaderFooterView * headerFooter = [super dequeueReusableHeaderFooterViewWithIdentifier:identifier];
  
  // Create a new view if none were available for dequeue
  if (headerFooter == nil)
  {
    headerFooter = [[CSEnhancedTableViewHeaderFooterView alloc] initWithTableViewStyle:[self tableViewStyleOrDefault] ReuseIdentifier:identifier];
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
  identifier = [NSString stringWithFormat:@"CSEnhancedTableViewCell-%@", identifier];
  
  // Dequeue a reusable view if available
  CSEnhancedTableViewCell * cell = [super dequeueReusableCellWithIdentifier:identifier];
  
  // Create a new view if none were available for dequeue
  if (cell == nil)
  {
    cell = [[CSEnhancedTableViewCell alloc] initWithTableViewStyle:[self tableViewStyleOrDefault] reuseIdentifier:identifier];
  }
  
  return cell;
}


@end
