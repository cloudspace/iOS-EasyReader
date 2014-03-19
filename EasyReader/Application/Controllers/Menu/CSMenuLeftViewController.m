//
//  CSMenuLeftViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSMenuLeftViewController.h"
#import "CSFeedAddViewController.h"

#import "Feed.h"
#import "User.h"
#import "CSAppDelegate.h"
#import "CSRootViewController.h"
#import "MFSideMenu.h"

#import <QuartzCore/QuartzCore.h>

#import "CSEnhancedTableView.h"
#import "CSEnhancedTableViewCell.h"
#import "CSEnhancedTableViewHeaderFooterView.h"
#import "CSEnhancedTableViewStyleDark.h"

@interface CSMenuLeftViewController ()

@end

@implementation CSMenuLeftViewController

/**
 * Sets up the table view, observers, and loads the core data feed list
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
//  // Set tableViewStyle
//  self.tableView_feeds.tableViewStyle =[[CSEnhancedTableViewStyleDark alloc] init];
//  
//  // Add observer
//  self.currentUser = [User current];
//  [self.currentUser addObserver:self forKeyPath:@"feeds" options:NSKeyValueObservingOptionNew context:nil];
//  
//  // Get feeds from core data
//  NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user == %@", self.currentUser];
//  NSArray *feedSorts = [FeedSort findAllSortedBy:@"sortValue" ascending:NO withPredicate:userPredicate];
//  
//  NSMutableArray *feeds = [NSMutableArray new];
//
//  for (FeedSort *feedSort in feedSorts)
//  {
//    [feeds addObject:feedSort.feed];
//  }
//  
//  self.feeds = [feeds copy];
//  
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                           selector:@selector(menuStateEventOccurred:)
//                                               name:MFSideMenuStateNotificationEvent
//                                             object:nil];
}

- (void)menuStateEventOccurred:(NSNotification *)notification {
  MFSideMenuStateEvent event = [[[notification userInfo] objectForKey:@"eventType"] intValue];

  __weak CSMenuLeftViewController *weakSelf = self;
  
    switch (event) {
      case MFSideMenuStateEventMenuWillOpen:
        // the menu will open
        break;
      case MFSideMenuStateEventMenuDidOpen:
        // the menu finished opening
        break;
      case MFSideMenuStateEventMenuWillClose:
        // the menu will close
        break;
      case MFSideMenuStateEventMenuDidClose:
        [weakSelf.tableView_feeds setEditing:NO animated:YES];
        weakSelf.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
        [weakSelf.tableView_feeds reloadData];
        break;
    }
}

///**
// * Watches for changes to the current users Feeds
// */
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//  if ([keyPath isEqualToString:@"feeds"])
//  {
//    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"user == %@", self.currentUser];
//    NSArray *feedSorts = [FeedSort findAllSortedBy:@"sortValue" ascending:NO withPredicate:userPredicate];
//    
//    NSMutableArray *feeds = [NSMutableArray new];
//    
//    for (FeedSort *feedSort in feedSorts)
//    {
//      if (feedSort.feed)
//      {
//        [feeds addObject:feedSort.feed];
//      }
//    }
//    
//    self.feeds = [feeds copy];
//    
//    //self.feeds = [[self.currentUser feeds] allObjects];
//    [self.tableView_feeds reloadData];
//    
//  }
//  else if ([keyPath isEqualToString:@" v"])
//  {
//    self.menuContainerViewController.panMode = MFSideMenuPanModeNone;
//  }
//}

/**
 * Removes all observers
 */
- (void)dealloc
{
  [self.currentUser removeObserver:self forKeyPath:@"feeds"];
}


#pragma mark - Actions
/**
 * Toggles edit mode for the table
 */
- (void)toggleEditMode:(id)sender
{
  [self.tableView_feeds beginUpdates];
  
  if ([self.tableView_feeds isEditing]) {
    // Stop editing, delete the 'Add new feed' row
    [self.tableView_feeds setEditing:NO animated:YES];
    self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
    [self.tableView_feeds deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self tableView:self.tableView_feeds numberOfRowsInSection:0]
                                                                      inSection:0]]
                                withRowAnimation:UITableViewRowAnimationFade];
    
    
  }
  else {
    // Start editing, add the 'Add new feed' row
    [self.tableView_feeds insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self tableView:self.tableView_feeds numberOfRowsInSection:0]
                                                                      inSection:0]]
                                withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView_feeds setEditing:YES animated:YES];
    self.menuContainerViewController.panMode = MFSideMenuPanModeNone;
  }
  
  [self.tableView_feeds endUpdates];
}


#pragma mark -
#pragma mark - UITableViewDataSource Methods -

#pragma mark - Count Methods
/**
 * Determines the number of sections in the table view
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

/**
 * Determines the number of rows in each section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (tableView.isEditing)
  {
    return [self.feeds count] + 1;
  }
  else
  {
    return [self.feeds count];
  }
  
}


#pragma mark - Size Methods
/**
 * Height of the header in each section
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 44;
}

/**
 * Height of all the cells
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 44;
}


#pragma mark - Header View
/**
 * Generates a view for the header in each section
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  //
  // Dequeue the header view
  //
  CSEnhancedTableViewHeaderFooterView *header = [self.tableView_feeds dequeueReusableHeaderFooterViewWithIdentifier:@"leftMenuHeader"];
  
  NSInteger headerWidth  = tableView.frame.size.width;
  
  //
  // Add edit button to first section
  //
  UIButton *button_edit = [[UIButton alloc] initWithFrame:CGRectMake(headerWidth - 84, 0, 74, 44)];
  [button_edit setTintColor:[UIColor colorWithRed:62/255.0 green:69/255.0 blue:88/255.0 alpha:1.0]];
  [button_edit setImage:[UIImage imageNamed:@"icon_pencil.png" ] forState:UIControlStateNormal];
  [button_edit addTarget:self action:@selector(toggleEditMode:) forControlEvents:UIControlEventTouchUpInside];

  [button_edit.imageView setContentMode:UIViewContentModeScaleAspectFit];
  [button_edit setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

  [header.contentView addSubview: button_edit];
  
  // Set label
  [header.titleLabel setText:[self tableView:tableView titleForHeaderInSection:section]];
  
  // Return the header
  return header;
}

/**
 * Determines the header title for each section
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  return @"MY FEEDS";
}


#pragma mark - Cell View
/**
 * Generates a cell for a given index path
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Dequeue a styled cell
  CSEnhancedTableViewCell *cell;
  
  // Set the content
  if (tableView.editing && indexPath.row == [self tableView:self.tableView_feeds numberOfRowsInSection:0] - 1)
  {
    cell = [self.tableView_feeds dequeueReusableCellWithIdentifier:@"leftMenuCellAdd"];
    
    // Set the label text
    [cell.textLabel setText:@"Add a new feed"];
    [cell.textLabel setFont:[UIFont fontWithName:@"Avenir-Black" size:14.0f]];
    [cell.textLabel setFrame:CGRectMake(15, 0, tableView.frame.size.width-44, 44)];
    [cell.imageView setHidden:YES];
  }
  else
  {
    cell = [self.tableView_feeds dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    
    // Set data based on feed name
    Feed *feed = self.feeds[indexPath.row];
    
    // Set the label text
    [cell.textLabel setText:feed.name];
    //cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.textLabel setFrame:CGRectMake(40, 0, tableView.frame.size.width, 44)];
    
    // Show feed icons
    [cell.imageView setHidden:NO];
    [cell.imageView setFrame:CGRectMake(0,0,44,44)];
    [cell.imageView setImage:[UIImage imageNamed:@"icon_rss@2x.png"]];
  }

  return cell;
}


#pragma mark - Editing
/**
 * Determines which rows are editable
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}

/**
 * Determines whether or not a row can be moved
 */
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  return indexPath.row < [self.feeds count];
}

/**
 * Handle moving rows
 */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
  NSMutableArray *reorderedFeeds = [self.feeds mutableCopy];
  
  id feedToMove =  [reorderedFeeds objectAtIndex:sourceIndexPath.row];
  [reorderedFeeds removeObjectAtIndex:sourceIndexPath.row];
  [reorderedFeeds insertObject:feedToMove atIndex:destinationIndexPath.row];


  for (NSInteger i = 0; i < [reorderedFeeds count]; i++)
  {
    Feed *currentFeed = reorderedFeeds[i];
    
//    NSPredicate *userFeedPredicate = [NSPredicate predicateWithFormat:@"user == %@ AND feed == %@", [User current], currentFeed];
//    FeedSort *feedSort = [FeedSort findFirstWithPredicate:userFeedPredicate];
//    feedSort.sortValue = [NSNumber numberWithInteger:[reorderedFeeds count] - i];
  }

  [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
  
  self.feeds = [reorderedFeeds copy];
  

}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
  if (proposedDestinationIndexPath.row < [self.feeds count] - 1)
  {
    return proposedDestinationIndexPath;
  }
  else
  {
    NSIndexPath *lastIndexPathInSection = [NSIndexPath indexPathForRow:[tableView numberOfRowsInSection:sourceIndexPath.section]-2
                                                             inSection:sourceIndexPath.section];
    
    return lastIndexPathInSection;
  }
}


/**
 * Commits each editing action
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleInsert)
  {    
    // Create (or edit) a feed
    CSFeedAddViewController *feedAddController = [CSFeedAddViewController new];
    
    if (indexPath.row < [self.feeds count])
    {
      feedAddController.feed = self.feeds[indexPath.row];
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:feedAddController];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self.rootViewController presentViewController:navController animated:YES completion:^{
      [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:^{}];
      [self toggleEditMode:nil];
    }];
    
    return;
  }
  else if (editingStyle == UITableViewCellEditingStyleDelete)
  {
    Feed *toDelete = self.feeds[indexPath.row];
    
    [toDelete deleteEntity];
    
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
  }
}

/**
 * Determines the editing style for each row
 */
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (!tableView.isEditing)
  {
    return UITableViewCellEditingStyleNone;
  }
  
  if (indexPath.section == 0 && indexPath.row == [self tableView:self.tableView_feeds numberOfRowsInSection:0] - 1)
  {
    return UITableViewCellEditingStyleInsert;
  }
  else
  {
    
    return UITableViewCellEditingStyleDelete;
  }
}


#pragma mark - UITableViewDelegate Methods
/**
 * Handles selection of a row
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Handle select while in edit mode
  if (tableView.isEditing)
  {
    [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];

    return;
  }

  // Handle normal select
  //User *user = [User current];
  
  [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
  [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:^{}];
}

@end
