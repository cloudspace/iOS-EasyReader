//
//  Feed.h
//  
//
//  Created by Michael Beattie on 3/11/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CSRemoteObject.h"

@class FeedItem, User;


#pragma mark - Feed -

/**
 * An RSS Feed
 */
@interface Feed : CSRemoteObject


#pragma mark  - Core Data Properties

/// This feed's icon
@property (nonatomic, retain) NSString * icon;

/// This feed's name
@property (nonatomic, retain) NSString * name;

/// This feed's RSS url
@property (nonatomic, retain) NSString * url;

/// The remote ID of this feed object on the API
@property (nonatomic, retain) NSNumber * id;

/// The user this feed is associated to
@property (nonatomic, retain) User *user;

/// The items in this feed
@property (nonatomic, retain) NSSet *feedItems;


#pragma mark - API Methods

/**
 * Creates a new feed based on a given url
 *
 * @param url The URL of the feed to create
 * @param successBlock A block to be run on API call success
 * @param failureBlock A block to be run on API call failure
 */
+ (void) createFeedWithUrl:(NSString *) url
                   success:(APISuccessBlock)successBlock
                   failure:(APIFailureBlock)failureBlock;

/**
 * Requests the default feeds list (called once on the first app run)
 *
 * @param successBlock A block to be run on API call success
 * @param failureBlock A block to be run on API call failure
 */
+ (void) requestDefaultFeedsWithSuccess:(APISuccessBlock)successBlock
                                failure:(APIFailureBlock)failureBlock;

/**
 * Requests a list of feeds by name (search)
 *
 * @param name The name to search feeds by
 * @param successBlock A block to be run on API call success
 * @param failureBlock A block to be run on API call failure
 */
+ (void) requestFeedsByName:(NSString *) name
                    success:(APISuccessBlock)successBlock
                    failure:(APIFailureBlock)failureBlock;


#pragma mark - Other Methods

/**
 * Delete all but the 10 newest feed items related to a feed
 */
- (void) purgeOldFeedItems;

@end


#pragma mark - Core Data Generated Accessors -

/**
 * Core data generated accessors
 */
@interface Feed (CoreDataGeneratedAccessors)

/**
 * Adds a FeedItem object to feedItems
 *
 * @param value The FeedItem to add
 */
- (void)addFeedItemsObject:(FeedItem *)value;

/**
 * Removes a FeedItem object from feedItems
 *
 * @param value The FeedItem to remove
 */
- (void)removeFeedItemsObject:(FeedItem *)value;

/**
 * Adds a set of FeedItem objects to feedItems
 *
 * @param values The FeedItems to add
 */
- (void)addFeedItems:(NSSet *)values;

/**
 * Removes a set of FeedItem objects from feedItems
 *
 * @param values The FeedItems to remove
 */
- (void)removeFeedItems:(NSSet *)values;

@end
