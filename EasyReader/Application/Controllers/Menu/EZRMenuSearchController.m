//
//  EZRMenuSearchBarDelegate.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRMenuSearchController.h"
#import "EZRMenuSearchFeedDataSource.h"
#import "EZRMenuUserFeedDataSource.h"
#import "EZRGoogleAnalyticsService.h"
#import "Feed.h"
#import "TSMessage.h"


NSString * const kEZRFeedSearchStateChangedNotification = @"kEZRFeedSearchStateChanged";


@interface EZRMenuSearchController ()

///// The feed search results data source
@property (nonatomic, weak) IBOutlet EZRMenuSearchFeedDataSource *feedSearchDataSource;

/// The search bar this delegate is for
@property (nonatomic, weak) IBOutlet EZRSearchBar *searchBar;

@end

@implementation EZRMenuSearchController
{
    /// The last term searched for.  Used to cancel previous requests when text changes.
    NSString *lastSearchTerm;
    
    BOOL searching;
}


#pragma mark - Public Methods

- (void)cancelSearch {
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    
    searching = NO;
    
    [self postSearchStateChangeNotification:kEZRSearchStateStoppedSearching];
}


#pragma mark - Private Methods

/**
 * Checks if the given string is a URL
 *
 * @param string The string to check
 */
- (BOOL)isURL:(NSString *)string {
    NSInteger length = [string length];
    
    if (
        (length > 6 && [[string substringWithRange:NSMakeRange(0, 7)] isEqualToString:@"http://"]) ||
        (length > 7 && [[string substringWithRange:NSMakeRange(0, 8)] isEqualToString:@"https://"])
    ) {
        return YES;
    } else {
        return NO;
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (!searching) {
        [self postSearchStateChangeNotification:kEZRSearchStateStartedSearching];
        searching = YES;
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self postSearchStateChangeNotification:kEZRSearchStateStoppedSearching];
    searching = NO;
}

/**
 *
 */
- (void)search:(NSString*)searchText
{
    // Cancel any previous requests
    if (lastSearchTerm) {
        [[Feed client] cancelOperationsForRoute:@"feedSearch" parameters:@{@"name": lastSearchTerm}];
    }
    
    lastSearchTerm = searchText;
    
    // Make a new request
    [Feed requestFeedsByName:searchText success:^(id responseObject, NSInteger httpStatus) {
        self.feedSearchDataSource.feedData = responseObject;
        [self postSearchStateChangeNotification:kEZRSearchStateResultsAvailable];
    } failure:^(id responseObject, NSInteger httpStatus, NSError *error) {
        self.feedSearchDataSource.feedData = nil;
        [self postSearchStateChangeNotification:kEZRSearchStateResultsAvailable];
    }];
}

/**
 *
 */
- (void)displayURL:(NSString*)searchText {
    self.feedSearchDataSource.feedData = @{
        @"feeds": @[
            @{@"name": searchText, @"url": searchText}
        ]
    };
    
    [self postSearchStateChangeNotification:kEZRSearchStateResultsAvailable];
}

- (void)postSearchStateChangeNotification:(EZRSearchState)state
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kEZRFeedSearchStateChangedNotification
                                                        object:nil
                                                      userInfo:@{
                                                                 @"searchState": [NSNumber numberWithInt:state],
                                                                 @"searchText": self.searchBar.text
                                                                 }];
}

#pragma mark - UISearchBarDelegate Methods

/**
 * Queries the API for feeds based on the search text
 * Switches the dataSource of the table view based on whether or not there is search text
 *
 * @param searchBar The searchBar
 * @param searchText The text entered in the search bar
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText length] > 0) {
        if ([self isURL:searchText]) {
            [self displayURL:searchText];
        } else {
            [self search:searchText];
        }
    } else {
        self.feedSearchDataSource.source = @[];
        [self postSearchStateChangeNotification:kEZRSearchStateResultsAvailable];
        return;
    }
}

/**
 * Hides the keyboard when the "search" (says "done" in this case) button is clicked
 * Resets the tableview data source back to the userFeedDataSource
 *
 * @param searchBar The search bar the button was clicked on
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([self isURL:searchBar.text]) {
        UIViewController *rootVC = [[[UIApplication sharedApplication].delegate window] rootViewController];
        
        [Feed createFeedWithUrl:searchBar.text success:^(id responseObject, NSInteger httpStatus) {
            [[EZRGoogleAnalyticsService shared] sendView:@"Feed Added"];
            [TSMessage showNotificationInViewController:rootVC title:@"Easy Reader" subtitle:@"The selected feed has been added to the menu.  Please allow a few minutes for new items to populate." type:TSMessageNotificationTypeSuccess];
        } failure:^(id responseObject, NSInteger httpStatus, NSError *error) {
            [TSMessage showNotificationInViewController:rootVC title:@"Easy Reader" subtitle:@"There was an error adding that feed.  Please try again later." type:TSMessageNotificationTypeError];
        }];
    }
    
    [self cancelSearch];
}


@end
