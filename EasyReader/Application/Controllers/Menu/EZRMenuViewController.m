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

/// Height Menu to modify
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *menuHeight;

@end


@implementation EZRMenuViewController
{
    /// Is the user currently searching
    BOOL searching;
    
    /// A temporary store for the menu height since it's made small when the keyboard shows
    CGFloat originalMenuHeight;
    
    /// Has the inital menu height been set to the frame (can not rely on autolayout since we're changing it when
    /// the keyboard shows
    BOOL hasSetMenuHeight;
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

- (void)viewDidLayoutSubviews {
    if (!hasSetMenuHeight) {
        self.menuHeight.constant = CGRectGetHeight(self.view.frame);
        hasSetMenuHeight = YES;
        [self.view layoutSubviews];
    }
}

- (void)applyMenuStyles
{
    UIImageView *background = [[UIImageView alloc] initWithFrame:self.view.frame];
    [background setImage:[UIImage imageNamed:@"menuBackground2"]];
    [self.view insertSubview:background atIndex:0];
}

- (void)feedsDidChange:(EZRCurrentFeedsProvider *)currentFeedProvider feeds:(NSArray *)feeds {
    ((CLDArrayTableViewDataSource *)self.tableView_menu.dataSource).source = self.currentFeedsProvider.feeds;
    [self.tableView_menu reloadData];
}

- (void)searchStateChanged:(NSNotification *)notification {
    EZRSearchState event = [[[notification userInfo] objectForKey:@"searchState"] intValue];
    
    switch (event) {
        case kEZRSearchStateStartedSearching:
        {
            originalMenuHeight = self.menuHeight.constant;
            
            self.tableView_menu.dataSource = self.searchFeedDataSource;
            self.searchFeedDataSource.source = @[];
            [self.searchFeedDataSource setLastSearchTerm:nil];
            self.menuHeight.constant = originalMenuHeight - 216;
            break;
        }
        case kEZRSearchStateStoppedSearching:
        {
            self.tableView_menu.dataSource = self.userFeedDataSource;
            self.menuHeight.constant = originalMenuHeight;
            break;
        }
        case kEZRSearchStateResultsAvailable:
            [self.searchFeedDataSource setLastSearchTerm:[[notification userInfo] objectForKey:@"searchText"]];
            
            // Do nothing, just need to reload
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
