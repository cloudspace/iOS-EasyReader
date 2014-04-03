//
//  CSMenuSearchFeedDataSource.h
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A UITableViewDataSource for custom and searched feeds returned by the API
 */
@interface CSMenuSearchFeedDataSource : NSObject<UITableViewDataSource>

#pragma mark - Properties

/// Feeds used to populate the menu table
@property (nonatomic, retain) NSMutableSet *feeds;

/// The sorted array of feeds
@property (nonatomic, strong) NSArray *sortedFeeds;


#pragma mark - Methods

/**
 * Updates the list of feeds used to populate the menu table
 *
 * @param feeds The feeds to update the list with
 */
- (void)updateWithFeeds:(NSMutableSet *)feeds;

@end
