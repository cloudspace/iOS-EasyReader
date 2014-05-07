//
//  CSMenuSearchFeedDataSource.h
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSArrayTableViewDataSource.h"

/**
 * A UITableViewDataSource for custom and searched feeds returned by the API
 */
@interface EZRMenuSearchFeedDataSource : CSArrayTableViewDataSource

#pragma mark - Properties

/// A dictionary of feed data to use as the base for this data source
@property (nonatomic, retain) NSDictionary *feedData;


#pragma mark - Methods

/**
 * Sets the last search term used.  This is used to determine which cell to display (no results, or empty).
 *
 * @param lastSearchTerm The most recent search term
 */
- (void) setLastSearchTerm:(NSString *)lastSearchTerm;


@end
