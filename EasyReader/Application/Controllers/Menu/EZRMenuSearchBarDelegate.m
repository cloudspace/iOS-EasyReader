//
//  EZRMenuSearchBarDelegate.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRMenuSearchBarDelegate.h"
#import "EZRMenuSearchFeedDataSource.h"
#import "EZRMenuUserFeedDataSource.h"
#import "Feed.h"

@interface EZRMenuSearchBarDelegate ()

/// The feed search results data source
@property (nonatomic, weak) IBOutlet EZRMenuSearchFeedDataSource *feedSearchDataSource;

/// The user feeds data source
@property (nonatomic, weak) IBOutlet EZRMenuUserFeedDataSource *userFeedDataSource;

/// The menu table view
@property (nonatomic, weak) IBOutlet UITableView *menuTableView;

@end

@implementation EZRMenuSearchBarDelegate
{
    NSString *lastSearchTerm;
}

/**
 *
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] > 0) {
        self.menuTableView.dataSource = self.feedSearchDataSource;
    } else {
        self.menuTableView.dataSource = self.userFeedDataSource;
    }
    
    // Cancel any previous requests
    if (lastSearchTerm) {
        [[Feed client] cancelOperationsForRoute:@"feedSearch" parameters:@{@"name": lastSearchTerm}];
    }
    
    lastSearchTerm = searchText;
    
    // Make a new request
    [Feed requestFeedsByName:searchText success:^(id responseObject, NSInteger httpStatus) {
        self.feedSearchDataSource.feedData = responseObject;
    } failure:^(id responseObject, NSInteger httpStatus, NSError *error) {
        self.feedSearchDataSource.feedData = nil;
    }];
}

/**
 * Hides the keyboard when the "search" (says "done" in this case) button is clicked
 *
 * @param searchBar The search bar the button was clicked on
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    self.menuTableView.dataSource = self.userFeedDataSource;
    [self.menuTableView reloadData];
    
}


@end
