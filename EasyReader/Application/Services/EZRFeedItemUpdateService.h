//
//  CSFeedItemUpdater.h
//  EasyReader
//
//  Created by Jeremiah Hemphill on 3/12/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A service that polls for feed item update every few minutes
 */
@interface EZRFeedItemUpdateService : NSObject

/**
 * Starts the feed update service
 */
- (void) start;

/**
 * Requests five minutes of feed items
 */
+ (void)requestFiveMinutesOfFeedItemsWithCompletion:(void (^)(BOOL success)) completion;

@end
