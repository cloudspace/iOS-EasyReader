//
//  CSMenuUserFeedDataSource.h
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A UITableViewDataSource for feeds in Core Data
 */
@interface CSMenuUserFeedDataSource : NSObject<UITableViewDataSource>

#pragma mark - Properties

/// The feeds this data source will use to provide table data
@property (nonatomic, retain) NSSet *feeds;


@end
