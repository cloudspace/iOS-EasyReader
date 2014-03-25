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

@interface CSMenuLeftViewController ()
{
    CSMenuUserFeedDataSource *userFeedDataSource;
    CSMenuSearchFeedDataSource *searchFeedDataSource;
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
                      [userFeedDataSource updateWithFeeds:self.feeds];
                      [self updateUserFeedDataSource];
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
    [self updateUserFeedDataSource];
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


#pragma mark - DataSource Methods
/**
 * Update the feeds in the menu when a user begins or ends a search
 */
- (void)searchFieldDidChange
{
    // If the searchInput has text
    if (self.textField_searchInput.text && self.textField_searchInput.text.length > 0) {
        
        // Create empty searchFeed set
        NSMutableSet *searchedFeeds = [[NSMutableSet alloc] init];
        
        // If the user is typing a url
        if ([self.textField_searchInput.text hasPrefix:@"http"]) {
            // Create a dictionary containing the new Feed url
            NSDictionary *customFeed = @{@"url" : self.textField_searchInput.text};
            
            // Add custom feed to the searchFeeds
            [searchedFeeds addObject:customFeed];
            
            // Update the searchFeed datasource
            [searchFeedDataSource updateWithFeeds:searchedFeeds];
            [self updateSearchFeedDataSource];
        } else {
            // Return feeds from the API similar to user input
            // Add these feeds to the searchFeed datasource

            [Feed requestFeedsByName:self.textField_searchInput.text
                             success:^(id responseData, NSInteger httpStatus){
                                NSDictionary *feeds = [responseData objectForKey:@"feeds"];
                                for ( NSDictionary *feed in feeds){
                                    [searchedFeeds addObject:feed];
                                }
                                // Update the searchFeed datasource
                                [searchFeedDataSource updateWithFeeds:searchedFeeds];
                                [self updateSearchFeedDataSource];
                             }
                             failure:^(id responseData, NSInteger httpStatus, NSError *error){
                                 NSLog(@"Error searching for feeds");
                             }];
        }
    } else {
        // Switch to the userFeeds datasource
        [self updateUserFeedDataSource];
    }
}

/**
 * Switch to and reload the menu from the searchFeedDataSource
 */
- (void)updateSearchFeedDataSource
{
    // Switch to the searchFeed datasource
    self.tableView_feeds.dataSource = searchFeedDataSource;
    
    // Reload the table with new searchFeeds
    [self.tableView_feeds reloadData];
}

/**
 * Switch to and reload the menu from the userFeedDataSource
 */
- (void)updateUserFeedDataSource
{
    // Clear the input field and dismiss the keyboard
    self.textField_searchInput.text = @"";
    [self.textField_searchInput endEditing:YES];
    
    // Switch to the searchFeed datasource
    self.tableView_feeds.dataSource = userFeedDataSource;
    
    // Reload the table with new searchFeeds
    [self.tableView_feeds reloadData];
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
