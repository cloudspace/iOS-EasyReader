//
//  CSMenuLeftViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "EZRMenuViewController.h"

#import "UIImageView+AFNetworking.h"

#import "UIColor+EZRSharedColorAdditions.h"

#import "Feed.h"
#import "FeedItem.h"
#import "User.h"
#import "EZRAppDelegate.h"
#import "EZRRootViewController.h"
#import "MFSideMenu.h"


#import "EZRMenuUserFeedDataSource.h"
#import "EZRMenuSearchFeedDataSource.h"
#import "EZRMenuSearchBarDelegate.h"

#import "EZRMenuAddFeedCell.h"
#import "EZRSearchFeedCell.h"

#import "EZRCurrentUserProxy.h"

#import "EZRMenuTableViewDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface EZRMenuViewController ()


@property IBOutlet EZRCurrentUserProxy *currentUserProxy;

@property IBOutlet EZRMenuSearchFeedDataSource *searchFeedDataSource;

@property IBOutlet EZRMenuUserFeedDataSource *userFeedDataSource;


@end


@implementation EZRMenuViewController

#pragma mark - UIViewController Lifecycle methods

/**
 * Sets up the table view, observers, and loads the core data feed list
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.feeds = [[NSMutableSet alloc] init];
    
    [self applyMenuStyles];

    [self.searchBar.textField setEnablesReturnKeyAutomatically:NO];
    [self.searchBar.textField setReturnKeyType:UIReturnKeyDone];
    [self.searchBar.textField setKeyboardAppearance:UIKeyboardAppearanceDark];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuStateEventOccurred:)
                                                 name:MFSideMenuStateNotificationEvent
                                               object:nil];
    
}



- (void)applyMenuStyles
{
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.frame];
    [background setImage:[UIImage imageNamed:@"menuBackground2"]];
    [self.view insertSubview:background atIndex:0];
}

- (void)menuStateEventOccurred:(NSNotification *)notification {
    MFSideMenuStateEvent event = [[[notification userInfo] objectForKey:@"eventType"] intValue];
    
    __weak EZRMenuViewController *weakSelf = self;
    
    switch (event) {
        case MFSideMenuStateEventMenuWillOpen:
            // the menu will open
            break;
        case MFSideMenuStateEventMenuDidOpen:
            // the menu finished opening
            [weakSelf.tableView_menu reloadData];
            break;
        case MFSideMenuStateEventMenuWillClose:
            // the menu will close
            [self.searchBar endEditing:YES];
            break;
        case MFSideMenuStateEventMenuDidClose:
            self.searchBar.text = @"";
            [weakSelf.tableView_menu setEditing:NO animated:YES];
            weakSelf.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
            
            // Reset to the users feeds
            weakSelf.tableView_menu.dataSource = self.userFeedDataSource;
            [weakSelf.tableView_menu reloadData];
            break;
    }
}


#pragma mark - DataSource Methods
/**
 * Update the feeds in the menu when a user begins or ends a search
 */
//- (void)searchFieldDidChange
//{
//    // If the searchInput has text
//    if (self.textField_searchInput.text && self.textField_searchInput.text.length > 0) {
//        
//        // Create empty searchFeed set
//        NSMutableSet *searchedFeeds = [[NSMutableSet alloc] init];
//        
//        // If the user is typing a url
//        if ([self.textField_searchInput.text hasPrefix:@"http"]) {
//            // Create a dictionary containing the new Feed url
//            NSDictionary *customFeed = @{@"url" : self.textField_searchInput.text};
//            
//            // Add custom feed to the searchFeeds
//            [searchedFeeds addObject:customFeed];
//            
//            // Update the searchFeed datasource
//            [searchFeedDataSource updateWithFeeds:searchedFeeds];
//            [self updateSearchFeedDataSource];
//        } else {
//            // Return feeds from the API similar to user input
//            // Add these feeds to the searchFeed datasource
//
//            [Feed requestFeedsByName:self.textField_searchInput.text
//                             success:^(id responseData, NSInteger httpStatus){
//                                NSDictionary *feeds = responseData[@"feeds"];
//                                 
//                                // Don't show feed the user has already added
//                                for ( NSDictionary *feed in feeds){
//                                    if ([self.currentUser hasFeedWithURL:feed[@"url"]] == NO) {
//                                        [searchedFeeds addObject:feed];
//                                    }
//                                }
//                                 
//                                // Update the searchFeed datasource
//                                [searchFeedDataSource updateWithFeeds:searchedFeeds];
//                                [self updateSearchFeedDataSource];
//                             }
//                             failure:^(id responseData, NSInteger httpStatus, NSError *error){
//                                 NSLog(@"Error searching for feeds");
//                             }];
//        }
//    } else {
//        // Switch to the userFeeds datasource
//        [self updateUserFeedDataSource];
//    }
//}
//
///**
// * Switch to and reload the menu from the searchFeedDataSource
// */
//- (void)updateSearchFeedDataSource
//{
//    // Switch to the searchFeed datasource
//    self.tableView_menu.dataSource = searchFeedDataSource;
//    
//    // Reload the table with new searchFeeds
//    [self.tableView_menu reloadData];
//}
//
///**
// * Switch to and reload the menu from the userFeedDataSource
// */
//- (void)updateUserFeedDataSource
//{
//    // Clear the input field and dismiss the keyboard
//    self.textField_searchInput.text = @"";
//    [self.textField_searchInput endEditing:YES];
//    
//    // Switch to the searchFeed datasource
//    self.tableView_menu.dataSource = userFeedDataSource;
//    
//    // Reload the table with new searchFeeds
//    [self.tableView_menu reloadData];
//}
//

#pragma mark - UITableViewCell IBAction Methods

/**
 * Attempts to create a new feed and save it to the user
 *
 * @param sender The button that sent the action
 */
- (IBAction)button_addCustomFeed_touchUpInside:(id)sender {
    EZRMenuAddFeedCell *cell = (EZRMenuAddFeedCell *)[[[sender superview] superview] superview];
    
    [Feed createFeedWithUrl:cell.label_url.text
                    success:^(id responseData, NSInteger httpStatus){
                        // Notify user that feeds can take time to populate
                    }
                    failure:^(id responseData, NSInteger httpStatus, NSError *error){
                        // Notify user of error
                    }
     ];
}

/**
 * Add the feed to the user and save it in the database
 *
 * @param sender The button that sent the action
 */
- (IBAction)button_addSearchedFeed_touchUpInside:(id)sender {
    EZRSearchFeedCell *cell = (EZRSearchFeedCell *)[[[sender superview] superview] superview];
    
    // Create a new Feed object and associated FeedItem objects
    Feed *newFeed = [Feed createOrUpdateFirstFromAPIData:cell.feedData];
    
    // Add the feed to the currentUsers feeds
    [self.currentUserProxy.user addFeedsObject:newFeed];
    
    // Save the feed and feed items in the database
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

@end
