//
//  CSMenuSearchFeedDataSource.h
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSMenuSearchFeedDataSource : NSObject<UITableViewDataSource>

#pragma mark - Properties
/**
 * Feeds used to populate the menu table
 */
@property (nonatomic, retain) NSMutableSet *feeds;


#pragma mark - Methods
/**
 * Updates the list of feeds used to populate the menu table
 */
- (void)updateWithFeeds:(NSMutableSet *)feeds;

@end
