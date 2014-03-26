//
//  User.h
//  
//
//  Created by Michael Beattie on 3/11/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CSRemoteObject.h"

@class Feed;

#pragma mark - User -

/**
 * An EasyReader User generally one per project
 */
@interface User : CSRemoteObject


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
