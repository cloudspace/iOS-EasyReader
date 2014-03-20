//
//  CSMenuLeftViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSMenuLeftViewController.h"
#import "CSFeedAddViewController.h"

#import "UIImageView+AFNetworking.h"


#import "User.h"
#import "Feed.h"
#import "FeedItem.h"
#import "CSAppDelegate.h"
#import "CSRootViewController.h"
#import "MFSideMenu.h"

#import <QuartzCore/QuartzCore.h>
#import <Block-KVO/MTKObserving.h>

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
  self.currentUser = [User current];
  self.feeds = [[NSMutableSet alloc] init];
  
  // Set tableViewStyle
  CSEnhancedTableViewStyle *tableViewStyle = [[CSEnhancedTableViewStyleDark alloc] init];
  self.tableView_feeds.tableViewStyle = tableViewStyle;
  
  [[self.textField_searchInput superview] setBackgroundColor: [tableViewStyle tableBackgroundColor]];
  [self.textField_searchInput setBackgroundColor: [tableViewStyle headerBackgroundTopColor]];
  self.textField_searchInput.textColor = [tableViewStyle headerTitleLabelTextColor];
   
  // Add observer
  //[self.currentUser addObserver:self forKeyPath:@"feeds" options:NSKeyValueObservingOptionNew context:nil];
  [self observeRelationship:@keypath(self.currentUser.feeds)
                changeBlock:^(__weak CSMenuLeftViewController *self, NSSet *old, NSSet *new) {
                  NSMutableArray *addedFeeds = [[new allObjects] mutableCopy];
                  NSMutableArray *removedFeeds = [[old allObjects] mutableCopy];
                  
                  [addedFeeds removeObjectsInArray:[old allObjects]];
                  [removedFeeds removeObjectsInArray:[new allObjects]];
                  
                  for ( Feed *feed in removedFeeds ){
                    [[self feeds] removeObject:feed];
                  }
                  
                  for ( Feed *feed in addedFeeds ){
                    [[self feeds] addObject:feed];
                  }
                }
             insertionBlock:nil
               removalBlock:nil
           replacementBlock:nil
   ];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(menuStateEventOccurred:)
                                               name:MFSideMenuStateNotificationEvent
                                             object:nil];
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
        [weakSelf.tableView_feeds reloadData];
        break;
      case MFSideMenuStateEventMenuWillClose:
        // the menu will close
        [self.textField_searchInput endEditing:YES];
        break;
      case MFSideMenuStateEventMenuDidClose:
        
        [weakSelf.tableView_feeds setEditing:NO animated:YES];
        weakSelf.menuContainerViewController.panMode = MFSideMenuPanModeNone;
        break;
    }
}

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
  return [_feeds count];// + 1;
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
  if (indexPath.row == [_feeds count])
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
    Feed *feed = [self.feeds allObjects][indexPath.row];
    
    // Set the label text
    [cell.textLabel setText:feed.name];
    //cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.textLabel setFrame:CGRectMake(40, 0, tableView.frame.size.width, 44)];
    
    // Show feed icons
    [cell.imageView setHidden:NO];
    [cell.imageView setFrame:CGRectMake(0,0,44,44)];
    
    __weak CSEnhancedTableViewCell *currentCell = cell;
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:feed.icon]];
    [currentCell.imageView setImageWithURLRequest:imageRequest
                                 placeholderImage:nil
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                            currentCell.imageView.image = image;
                                          }failure:nil
     ];
    
    //[cell setUserInteractionEnabled:NO];
  }

  return cell;
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
      feedAddController.feed = [self.feeds allObjects][indexPath.row];
    }
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:feedAddController];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self.rootViewController presentViewController:navController animated:YES completion:^{
      [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:^{}];
    }];
    
    return;
  }
  else if (editingStyle == UITableViewCellEditingStyleDelete)
  {
    Feed *toDelete = [self.feeds allObjects][indexPath.row];
    
    [self.feeds removeObject:toDelete];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    for( FeedItem *item in toDelete.feedItems ) [item deleteEntity];
    [toDelete deleteEntity];
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
  }
}

/**
 * Determines the editing style for each row
 */
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ( indexPath.row == [_feeds count] )
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
  if (indexPath.row == [_feeds count])
  {
    //Add new feed controller change
  } else {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
  
  //[self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:^{}];
}

@end
