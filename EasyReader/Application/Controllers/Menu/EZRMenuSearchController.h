//
//  EZRMenuSearchBarDelegate.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, EZRSearchState) {
    kEZRSearchStateStartedSearching,
    kEZRSearchStateResultsAvailable,
    kEZRSearchStateStoppedSearching,
};

extern NSString * const kEZRFeedSearchStateChangedNotification;


/**
 * Handles search actions from the menu
 *
 * Switches out the tableView data source between the 
 * Acts as the delegate object for the menu search bar
 */
@interface EZRMenuSearchController : NSObject <UISearchBarDelegate>


/// The search bar this delegate is for
@property (nonatomic, weak) IBOutlet EZRSearchBar *searchBar;

/**
 * Cancels a search, clears the search text, hides the keyboard
 */
- (void)cancelSearch;

@end
