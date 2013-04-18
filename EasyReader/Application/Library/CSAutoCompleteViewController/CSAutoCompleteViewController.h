//
//  CSAutoCompleteViewController.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/16/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSBaseViewController.h"
#import "AFNetworking.h"

// Forward class definitions
@class CSAutoCompleteViewController, CSStyledTableView;


#pragma mark - CSAutoCompleteDelegate Protocol
/**
 * A set of methods used with interacting with the AutoCompleteViewController
 */
@protocol CSAutoCompleteDelegate


@required

/**
 * Fires when the search term changes
 */
- (void) autoComplete:(CSAutoCompleteViewController *)viewController
  didChangeSearchTerm:(NSString *)searchTerm
           onComplete:(void (^)(NSArray *autoCompleteData))setAutoCompleteData;

@optional


/**
 * Fires when a row is selected
 */
- (void) autoComplete:(CSAutoCompleteViewController *)viewController didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Fires when a row is selected
 */
- (void) autoComplete:(CSAutoCompleteViewController *)viewController didSelectImageAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Fires when the default list needs to be loaded
 */
- (void) autoComplete:(CSAutoCompleteViewController *)viewController loadDefaultList:(void (^)(NSArray *autoCompleteData))setDefaultList;

/**
 * Fires when the search button was pressed
 */
- (void) autoComplete:(CSAutoCompleteViewController *)viewController  didPressSearchWithTerm:(NSString *)searchTerm;

/**
 * Fires when the search button was pressed
 */
- (void) didPressCancelbuttonForAutoComplete:(CSAutoCompleteViewController *)viewController;


@end


#pragma mark - CSAutoCompleteviewController
@interface CSAutoCompleteViewController : CSBaseViewController <
  UISearchBarDelegate,
  UITableViewDelegate,
  UITableViewDataSource,
  UIGestureRecognizerDelegate
>

#pragma mark - Members
{
  NSString *_searchTerm; ///< A member string to hold the contents of the search term property
}


#pragma mark - IBOutlet Properties
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;               ///< The search bar in the view
@property (nonatomic, retain) IBOutlet CSStyledTableView *tableView_results; ///< The results table view


#pragma mark - Properties
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSArray *autoCompleteData;
//@property (nonatomic, retain) YUMURLConnection *autoCompleteConnction;


#pragma mark - Instance Methods
/**
 * The search term currently being used
 */
- (NSString *) searchTerm:(NSString *)searchTerm;

/**
 * Sets the search term for the view controller
 */
- (void)    setSearchTerm:(NSString *)searchTerm;



@end
