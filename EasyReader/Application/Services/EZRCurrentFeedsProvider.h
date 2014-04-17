//
//  EZRCurrentFeedsService.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/15/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A data provider class that contains up-to-date, sorted, lists of feeds and feedItems
 */
@interface EZRCurrentFeedsProvider : NSObject


/// All feeds
@property (nonatomic, retain) NSArray *feeds;

/// All feed items
@property (nonatomic, retain) NSArray *feedItems;

/// All feed items that should be visible
@property (nonatomic, retain) NSArray *visibleFeedItems;


#pragma mark - Methods

/**
 * Returns a shared instance of the current feeds service
 */
+ (EZRCurrentFeedsProvider *) shared;

@end
