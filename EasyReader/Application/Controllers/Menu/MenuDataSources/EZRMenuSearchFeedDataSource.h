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

/// A dictionary of feed data to use as the base for this data source
@property (nonatomic, retain) NSDictionary *feedData;

@end
