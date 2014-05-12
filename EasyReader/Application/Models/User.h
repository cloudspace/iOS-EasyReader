//
//  User.h
//  
//
//  Created by Michael Beattie on 3/11/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "APIRemoteObject.h"

@class Feed;

#pragma mark - User -

/**
 * An EasyReader User generally one per project
 */
@interface User : APIRemoteObject


#pragma mark - Core Data Properties

/// The users feeds
@property (nonatomic, retain) NSSet *feeds;

/// The items in a users feeds
@property (nonatomic, readonly) NSSet *feedItems;


#pragma mark - Methods

/**
 * Gets the current user (a singleton shared user)
 */
+ (User *)current;

/**
 * Sets the current user
 *
 * @param user The new current user
 */
+ (void) setCurrent:(User *)user;

/**
 * Check if the feed already exists for the user
 *
 * @param url The url of the feed to check for
 */
- (BOOL)hasFeedWithURL:(NSString *)url;

@end


#pragma mark - Core Data Generated Accessors -

/**
 * Core data generated accessors
 */
@interface User (CoreDataGeneratedAccessors)

/**
 * Adds a feed object to feeds
 *
 * @param value The feed to add
 */
- (void)addFeedsObject:(Feed *)value;

/**
 * Removes a feed object from feeds
 *
 * @param value The feed to remove
 */
- (void)removeFeedsObject:(Feed *)value;

/**
 * Adds a new set of Feed objects to feeds
 *
 * @param values The feeds to add
 */
- (void)addFeeds:(NSSet *)values;

/**
 * Removes a set of Feed objects from feeds
 *
 * @param values The feeds to remove
 */
- (void)removeFeeds:(NSSet *)values;

@end
