//
//  CSMenuLeftViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "EZRMenuViewController.h"
#import "EZRMenuUserFeedDataSource.h"

#import "MFSideMenu.h"


@interface EZRMenuViewController ()

/// A data source that provides information about the current users feeds
@property IBOutlet EZRMenuUserFeedDataSource *userFeedDataSource;

/// The feeds table view
@property (nonatomic, weak) IBOutlet UITableView *tableView_menu;

/// The search input bar
@property (nonatomic, weak) IBOutlet EZRSearchBar *searchBar;

@end


@implementation EZRMenuViewController

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
            
            // Reset to the users feeds data source
            weakSelf.tableView_menu.dataSource = self.userFeedDataSource;
            [weakSelf.tableView_menu reloadData];
            break;
    }
}

@end
