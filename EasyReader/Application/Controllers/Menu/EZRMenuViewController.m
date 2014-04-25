//
//  CSMenuLeftViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "EZRMenuViewController.h"
#import "EZRMenuUserFeedDataSource.h"

#import "EZRCurrentFeedsProvider.h"

#import "MFSideMenu.h"

#import <Block-KVO/MTKObserving.h>

#import "EZRMenuSearchController.h"


#import "EZRMenuFeedCell.h"
#import "EZRSearchFeedCell.h"

#import "EZRMenuSearchFeedDataSource.h"

@interface EZRMenuViewController ()

/// A data source that provides information about the current users feeds
@property (nonatomic, weak) IBOutlet EZRMenuUserFeedDataSource *userFeedDataSource;

/// A data source that provides information about the current users feeds
@property (nonatomic, weak) IBOutlet EZRMenuSearchFeedDataSource *searchFeedDataSource;

/// The feeds table view
@property (nonatomic, weak) IBOutlet UITableView *tableView_menu;

/// The search input bar
@property (nonatomic, weak) IBOutlet EZRSearchBar *searchBar;

/// The current feeds provider
@property (nonatomic, strong) EZRCurrentFeedsProvider *currentFeedsProvider;

@end


@implementation EZRMenuViewController
{
    /// Is the user currently searching
    BOOL searching;
}

#pragma mark - UIViewController Lifecycle methods

/**
 * Sets up the table view, observers, and loads the core data feed list
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self applyMenuStyles];

    [self.searchBar.textField setEnablesReturnKeyAutomatically:NO];
    [self.searchBar.textField setReturnKeyType:UIReturnKeyDone];
    [self.searchBar.textField setKeyboardAppearance:UIKeyboardAppearanceDark];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(menuStateEventOccurred:)
                                                 name:MFSideMenuStateNotificationEvent
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchStateChanged:)
                                                 name:kEZRFeedSearchStateChangedNotification
                                               object:nil];
    
    self.currentFeedsProvider = [EZRCurrentFeedsProvider shared];
    
    [self observeObject:self.currentFeedsProvider property:@"feeds" withSelector:@selector(feedsDidChange:feeds:)];
}

- (void)applyMenuStyles
{
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.frame];
    [background setImage:[UIImage imageNamed:@"menuBackground2"]];
    [self.view insertSubview:background atIndex:0];
}

- (void)feedsDidChange:(EZRCurrentFeedsProvider *)currentFeedProvider feeds:(NSArray *)feeds {
    ((CSArrayTableViewDataSource *)self.tableView_menu.dataSource).source = self.currentFeedsProvider.feeds;
    [self.tableView_menu reloadData];
}

- (void)searchStateChanged:(NSNotification *)notification {
    EZRSearchState event = [[[notification userInfo] objectForKey:@"searchState"] intValue];
    
    CGRect oldFrame = self.menuContainerViewController.leftMenuViewController.view.frame;
    UIViewController *newLeftController = self.menuContainerViewController.leftMenuViewController;
    
    switch (event) {
        case kEZRSearchStateStartedSearching:
        {
            self.tableView_menu.dataSource = self.searchFeedDataSource;
            
            newLeftController.view.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, 361.0);
            self.menuContainerViewController.leftMenuViewController = newLeftController;
            [[(EZRMenuSearchController *)newLeftController searchBar] becomeFirstResponder];
            
            break;
        }
        case kEZRSearchStateStoppedSearching:
            self.tableView_menu.dataSource = self.userFeedDataSource;
            
            newLeftController.view.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, 568.0);
            self.menuContainerViewController.leftMenuViewController = newLeftController;
            
            break;
            
        case kEZRSearchStateResultsAvailable:
            // Do nothing, just need to realod
            break;
    }
    
    [self.tableView_menu reloadData];
}

- (void)menuStateEventOccurred:(NSNotification *)notification {
    MFSideMenuStateEvent event = [[[notification userInfo] objectForKey:@"eventType"] intValue];
    
    switch (event) {
        case MFSideMenuStateEventMenuWillOpen:
            // the menu will open
            break;
        case MFSideMenuStateEventMenuDidOpen:
            // the menu finished opening
            [self.tableView_menu reloadData];
            break;
        case MFSideMenuStateEventMenuWillClose:
            // the menu will close
            [self.searchBar endEditing:YES];
            break;
        case MFSideMenuStateEventMenuDidClose:
            self.searchBar.text = @"";
            [self.tableView_menu setEditing:NO animated:YES];
            self.menuContainerViewController.panMode = MFSideMenuPanModeDefault;
            
            // Reset to the users feeds data source
            self.tableView_menu.dataSource = self.userFeedDataSource;
            [self.tableView_menu reloadData];
            break;
    }
}

@end
