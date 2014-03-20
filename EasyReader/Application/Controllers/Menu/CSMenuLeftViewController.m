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

#import "Feed.h"
#import "User.h"
#import "CSAppDelegate.h"
#import "CSRootViewController.h"
#import "MFSideMenu.h"

#import <QuartzCore/QuartzCore.h>
#import <Block-KVO/MTKObserving.h>

#import "CSEnhancedTableView.h"
#import "CSEnhancedTableViewCell.h"
#import "CSEnhancedTableViewHeaderFooterView.h"
#import "CSEnhancedTableViewStyleDark.h"

#import "CSMenuUserFeedDataSource.h"

@interface CSMenuLeftViewController ()
{
    CSMenuUserFeedDataSource *userFeedDataSource;
}

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
  self.usersFeeds = [[NSMutableSet alloc] init];
  [self setUpDataSources];
  
  // Set tableViewStyle
  CSEnhancedTableViewStyle *tableViewStyle = [[CSEnhancedTableViewStyleDark alloc] init];
  self.tableView_feeds.tableViewStyle = tableViewStyle;
  
  [[self.textField_searchInput superview] setBackgroundColor: [tableViewStyle tableBackgroundColor]];
  [self.textField_searchInput setBackgroundColor: [tableViewStyle headerBackgroundTopColor]];
  self.textField_searchInput.textColor = [tableViewStyle headerTitleLabelTextColor];
   
  [self.textField_searchInput addTarget:self action:@selector(searchFieldDidChange)forControlEvents:UIControlEventEditingChanged];
    
  // Add observer
  //[self.currentUser addObserver:self forKeyPath:@"feeds" options:NSKeyValueObservingOptionNew context:nil];
  [self observeRelationship:@keypath(self.currentUser.feeds)
                changeBlock:^(__weak CSMenuLeftViewController *self, NSSet *old, NSSet *new) {
                  NSMutableArray *addedFeeds = [[new allObjects] mutableCopy];
                  NSMutableArray *removedFeeds = [[old allObjects] mutableCopy];
                  
                  [addedFeeds removeObjectsInArray:[old allObjects]];
                  [removedFeeds removeObjectsInArray:[new allObjects]];
                  
                  for ( Feed *feed in removedFeeds ){
                    [[self usersFeeds] removeObject:feed];
                  }
                  
                  for ( Feed *feed in addedFeeds ){
                    [[self usersFeeds] addObject:feed];
                  }
                  self.feeds = self.usersFeeds;
                  [self.tableView_feeds reloadData];
                }
             insertionBlock:nil
               removalBlock:nil
           replacementBlock:nil
   ];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(menuStateEventOccurred:)
                                               name:MFSideMenuStateNotificationEvent
                                             object:nil];

    self.tableView_feeds.delegate = self;
    self.tableView_feeds.dataSource = userFeedDataSource;
    [userFeedDataSource updateWithFeeds:self.feeds];
    
    self.searchingFeeds = NO;
}

- (void)setUpDataSources
{
    userFeedDataSource = [[CSMenuUserFeedDataSource alloc] init];
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
        weakSelf.textField_searchInput.text = @"";
        [weakSelf.tableView_feeds setEditing:NO animated:YES];
        weakSelf.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
        break;
    }
}

- (void)searchFieldDidChange
{
    if(self.textField_searchInput.text && self.textField_searchInput.text.length > 0){
        self.searchingFeeds = YES;
        NSMutableSet *searchedFeeds = [[NSMutableSet alloc] init];
        if([self.textField_searchInput.text hasPrefix:@"http"]){
            NSLog(@"ADDING A URL");
        }
        else{
             NSLog(@"SEARCHING");
        }
        
        self.feeds = searchedFeeds;
        [self.tableView_feeds reloadData];
    }
    else{
        self.searchingFeeds = NO;
        self.feeds = self.usersFeeds;
        [self.tableView_feeds reloadData];
    }
}


#pragma mark - Count Methods
/**
 * Determines the number of sections in the table view
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
