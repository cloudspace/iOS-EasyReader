//
//  CSMenuLeftViewController.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"

@class User;

/**
 * The menu view controller
 */
@interface EZRMenuViewController : CSBaseViewController


#pragma mark - IBOutlet Properties

/// The feeds table view
@property (nonatomic, retain) IBOutlet UITableView *tableView_menu;

/// The search input text field
@property (strong, nonatomic) IBOutlet UITextField *textField_searchInput;


#pragma mark - Properties

/// The current array of feeds
@property (nonatomic, retain) NSMutableSet *feeds;

/// The current sorted array of feeds
@property (nonatomic, readonly) NSArray *sortedFeeds;

/// The current user
@property (nonatomic, retain) User *currentUser;


#pragma mark - IBActions

/**
 * The add custom feed action
 *
 * @param sender The event triggering object
 */
- (IBAction)button_addCustomFeed_touchUpInside:(id)sender;

/**
 * The add searched feed action
 *
 * @param sender The event triggering object
 */
- (IBAction)button_addSearchedFeed_touchUpInside:(id)sender;


@end
