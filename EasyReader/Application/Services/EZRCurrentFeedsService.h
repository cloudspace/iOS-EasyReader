//
//  EZRCurrentFeedsService.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/15/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A service that provides up-to-date, sorted, lists of feeds and feedItems
 */
@interface EZRCurrentFeedsService : NSObject


/// All feeds
@property (nonatomic, readonly) NSArray *feeds;

/// All feed items
@property (nonatomic, readonly) NSArray *feedItems;

/// All feed items that should be visible
@property (nonatomic, readonly) NSArray *visibleFeedItems;


#pragma mark - Methods

/**
 * Returns a shared instance of the current feeds service
 */
+ (EZRCurrentFeedsService *) shared;

@end
