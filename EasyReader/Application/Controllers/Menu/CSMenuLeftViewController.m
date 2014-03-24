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

#import "UIColor+EZRSharedColorAdditions.h"

#import "Feed.h"
#import "FeedItem.h"
#import "User.h"
#import "CSAppDelegate.h"
#import "CSRootViewController.h"
#import "MFSideMenu.h"

#import <QuartzCore/QuartzCore.h>
#import <Block-KVO/MTKObserving.h>

#import "CSMenuUserFeedDataSource.h"
#import "CSMenuSearchFeedDataSource.h"

#import "CSFeedSearcher.h"

@interface CSMenuLeftViewController ()
{
    CSMenuUserFeedDataSource *userFeedDataSource;
    CSMenuSearchFeedDataSource *searchFeedDataSource;
    CSFeedSearcher *feedSearcher;
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
    
    // Setup the user and search datasources
    [self setUpDataSources];
    self.tableView_feeds.delegate = self;
    
    // Setup feedSearch API requestor
    feedSearcher = [[CSFeedSearcher alloc] init];
    
    // Set tableViewStyle
    [self applyMenuStyles];
    
    // Added search method to the user input field
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
                          [[self feeds] removeObject:feed];
                      }
                      
                      for ( Feed *feed in addedFeeds ){
                          [[self feeds] addObject:feed];
                      }
                      
                      // Update and switch to the userFeed data source
                      self.tableView_feeds.dataSource = userFeedDataSource;
                      [userFeedDataSource updateWithFeeds:self.feeds];
                      
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
    
    [userFeedDataSource updateWithFeeds:self.feeds];
    self.tableView_feeds.dataSource = userFeedDataSource;
}

- (void)applyMenuStyles
{
    [self.tableView_feeds setBackgroundColor: [UIColor EZR_menuBackground]];
    [self.textField_searchInput setBackgroundColor: [UIColor EZR_menuInputBackground]];
    [self.textField_searchInput setTextColor: [UIColor whiteColor]];
    [self.tableView_feeds setSeparatorColor: [UIColor EZR_charcoal]];
}

- (void)setUpDataSources
{
    // Lists feeds in the database
    userFeedDataSource = [[CSMenuUserFeedDataSource alloc] init];
    
    // Lists feeds returned by the search API
    searchFeedDataSource = [[CSMenuSearchFeedDataSource alloc] init];
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
            weakSelf.menuContainerViewController.panMode = MFSideMenuPanModeNone;
            
            // Reset to the users feeds
            weakSelf.tableView_feeds.dataSource = userFeedDataSource;
            [weakSelf.tableView_feeds reloadData];
            break;
    }
}

/**
 * Update the feeds in the menu when a user begins or ends a search
 */
- (void)searchFieldDidChange
{
    // If the searchInput has text
    if (self.textField_searchInput.text && self.textField_searchInput.text.length > 0) {
        
        // Create empty searchFeed set
        NSMutableSet *searchedFeeds = [[NSMutableSet alloc] init];
        
        // Switch to the searchFeed datasource and update the table
        [searchFeedDataSource updateWithFeeds:searchedFeeds];
        self.tableView_feeds.dataSource = searchFeedDataSource;
        
        // If the user is typing a url
        if ([self.textField_searchInput.text hasPrefix:@"http"]) {
            // Get the local context
            NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
            
            // Create a new Feed in the current thread context
            Feed *customFeed = [Feed MR_createInContext:localContext];
            customFeed.name = self.textField_searchInput.text;
            customFeed.url = self.textField_searchInput.text;
            
            // Add custom feed to the searchFeeds
            [searchedFeeds addObject:customFeed];
        } else {
            // Return feeds from the API similar to user input
            // Add these feeds to the searchFeed datasource
            [feedSearcher feedsLike:self.textField_searchInput.text];
        }
        
        // Reload the table with new searchFeeds
        [self.tableView_feeds reloadData];
    } else {
        // Switch to the userFeeds datasource
        self.tableView_feeds.dataSource = userFeedDataSource;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
