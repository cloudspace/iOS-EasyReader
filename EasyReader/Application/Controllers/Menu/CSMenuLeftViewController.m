//
//  CSMenuLeftViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSMenuLeftViewController.h"
#import "CSBaseView.h"
#import "CSFeedCreateViewController.h"

#import "Feed.h"
#import "User.h"

#import "CSAppDelegate.h"
#import "CSRootViewController.h"
#import "MFSideMenu.h"

#import <QuartzCore/QuartzCore.h>

#import "CSStyledTableView.h"
#import "CSStyledTableViewCell.h"
#import "CSStyledTableViewHeaderFooterView.h"

@interface CSMenuLeftViewController ()

@end

@implementation CSMenuLeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
      
    }
    return self;
}


- (void)viewDidLoad
{
  [super viewDidLoad];

  // Add observer
  self.currentUser = [User current];
  [self.currentUser addObserver:self forKeyPath:@"feeds" options:NSKeyValueObservingOptionNew context:nil];
  
  // Get feeds from core data
  self.feeds = [[self.currentUser feeds] allObjects];
}

/**
 * Watches for changes to the current users Feeds
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if ([keyPath isEqualToString:@"feeds"])
  {
    self.feeds = [[self.currentUser feeds] allObjects];
    [self.tableView_feeds reloadData];
    
  }
}

/**
 * Removes all observers
 */
- (void)dealloc
{
  [self.currentUser removeObserver:self forKeyPath:@"feeds"];
}


#pragma mark - UITableViewDataSource Methods
// Height of the header in each section
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 44;
}

// Height of all the cells
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 44;
}

// Generates a view for the header in each section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  //
  // Dequeue the header view
  //
  CSStyledTableViewHeaderFooterView *header = [self.tableView_feeds dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
  
  NSInteger headerWidth  = tableView.frame.size.width;
  
  //
  // Add edit button to first section
  //
  UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(headerWidth - 44, 0, 44, 44)];
  [button setTintColor:[UIColor colorWithRed:62/255.0 green:69/255.0 blue:88/255.0 alpha:1.0]];
  [button setImage:[UIImage imageNamed:@"Images/Icons/icon_pencil@2x.png" ] forState:UIControlStateNormal];
  [button addTarget:self action:@selector(toggleEditMode:) forControlEvents:UIControlEventTouchUpInside];
  [header.contentView addSubview: button];
  
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
  return @"ALL FEEDS";
}

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

/**
 * Generates a cell for a given index path
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Dequeue a styled cell
  CSStyledTableViewCell *cell = [self.tableView_feeds dequeueReusableCellWithIdentifier:@"cell"];
  
  // Set the content
  if (tableView.editing && indexPath.row == [self tableView:self.tableView_feeds numberOfRowsInSection:0] - 1)
  {
    // Set the label text
    [cell.textLabel setText:@"Add a new feed"];
  }
  else
  {
    // Set data based on feed name
    Feed *feed = self.feeds[indexPath.row];
    
    // Set the label text
    [cell.textLabel setText:feed.name];
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.textLabel setFrame:CGRectMake(40, 0, tableView.frame.size.width, 44)];
    
    // Show feed icons
    [cell.imageView setFrame:CGRectMake(0,0,44,44)];
    [cell.imageView setImage:[UIImage imageNamed:@"Images/Icons/icon_rss@2x.png"]];
  }

  return cell;
}

/**
 * Determines which rows are editable
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
}

/**
 * Commits each editing action
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (editingStyle == UITableViewCellEditingStyleInsert)
  {    
    // Create (or edit) a feed
    CSFeedCreateViewController *feedCreateController = [CSFeedCreateViewController new];
    
    if (indexPath.row < [self.feeds count])
    {
      feedCreateController.feed = self.feeds[indexPath.row];
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:feedCreateController];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self.rootViewController presentViewController:navController animated:YES completion:^{
      [self.rootViewController.sideMenu setMenuState:MFSideMenuStateClosed];
      [self toggleEditMode:nil];
    }];
    
    return;
  } else if (editingStyle == UITableViewCellEditingStyleDelete)
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
  //
  // Handle add on edit mode
  //
  if (tableView.isEditing)
  {
    [self tableView:tableView commitEditingStyle:UITableViewCellEditingStyleInsert forRowAtIndexPath:indexPath];

    return;
  }

  User *user = [User current];
  user.activeFeed = self.feeds[indexPath.row];
  
  [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
  [self.rootViewController.sideMenu setMenuState:MFSideMenuStateClosed];
}


#pragma mark - Actions
/**
 * Toggles edit mode for the table
 */
- (void)toggleEditMode:(id) sender
{
  [self.tableView_feeds beginUpdates];
  
  if ([self.tableView_feeds isEditing]) {
    // Stop editing, delete the 'Add new feed' row
    [self.tableView_feeds setEditing:NO animated:YES];
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
  }
  
  [self.tableView_feeds endUpdates];
}


@end
