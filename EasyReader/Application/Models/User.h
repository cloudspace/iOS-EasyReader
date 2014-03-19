//
//  User.h
//  
//
//  Created by Michael Beattie on 3/11/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CSBaseObject.h"

@class Feed;

#pragma mark - User -

/**
 * An EasyReader User generally one per project
 */
@interface User : CSBaseObject


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

@interface User (CoreDataGeneratedAccessors)

- (void)addFeedsObject:(Feed *)value;
- (void)removeFeedsObject:(Feed *)value;
- (void)addFeeds:(NSSet *)values;
- (void)removeFeeds:(NSSet *)values;

@end
