//
//  CSAutoCompleteViewController.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/16/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSBaseViewController.h"

@class CSAutoCompleteViewController;

#pragma mark - CSAutoCompleteDelegate Protocol
@protocol CSAutoCompleteDelegate

@required

- (void) autoCompleteTextDidChange:(CSAutoCompleteViewController *)viewController
                        searchText:(NSString *)searchText
                        onComplete:(void (^)(NSArray *))onComplete;

@optional

- (void) autoCompleteGetDefaultList: (CSAutoCompleteViewController *)viewController  onComplete:(void (^)(NSArray *))onComplete;
- (void) autoCompleteDidSelectItem:  (CSAutoCompleteViewController *)viewController atIndexPath:(NSIndexPath *)indexPath;
- (void) autoCompleteDidSelectImage: (CSAutoCompleteViewController *)viewController atIndexPath:(NSIndexPath *)indexPath  searchText:(NSString *)searchText;
- (void) autoCompleteDidSelectImage: (CSAutoCompleteViewController *)viewController atIndexPath:(NSIndexPath *)indexPath;
- (void) autoCompleteDidPressSearch: (CSAutoCompleteViewController *)viewController  searchText:(NSString *)searchText;

@end

#pragma mark - CSAutoCompleteviewController
@interface CSAutoCompleteViewController : CSBaseViewController <UISearchBarDelegate, UITableViewDelegate>


#pragma mark - IBOutlet Properties
@property (nonatomic, retain) IBOutlet UISearchBar *search_bar;
@property (nonatomic, retain) IBOutlet UITableView *table_view_results;


#pragma mark - Instance Methods
- (void) setReceivedSearch :(NSString *)term;
- (NSString *) receivedSearch;


@end
