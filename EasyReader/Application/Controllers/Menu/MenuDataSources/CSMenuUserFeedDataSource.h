//
//  CSMenuUserFeedDataSource.h
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

/**
 * A UITableViewDataSource for feeds in Core Data
 */
@interface CSMenuUserFeedDataSource : NSObject<UITableViewDataSource>

#pragma mark - Properties


/// Feeds used to populate the menu table
@property (nonatomic, retain) NSMutableSet *feeds;

/// The properly sorted array of feeds
@property (nonatomic, readonly) NSArray *sortedFeeds;


#pragma mark - Methods

/**
 * Updates the list of feeds used to populate the menu table
 *
 * @param feeds Sets and sorts the feeds
 */
- (void)updateWithFeeds:(NSMutableSet *)feeds;

/**
 * Initializes a new menu data source
 *
 * @param menuController the menu view controller
 */
- (instancetype)initWithController:(EZRMenuViewController *)menuController;

@end