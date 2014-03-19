//
//  Feed.h
//  
//
//  Created by Michael Beattie on 3/11/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CSBaseObject.h"

@class FeedItem, User;

/**
 * An RSS Feed
 */
@interface Feed : CSBaseObject


#pragma mark - Core Data Properties

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


@end


/**
 * Core data generated accessor category
 */
@interface Feed (CoreDataGeneratedAccessors)

- (void)addFeedItemsObject:(FeedItem *)value;
- (void)removeFeedItemsObject:(FeedItem *)value;
- (void)addFeedItems:(NSSet *)values;
- (void)removeFeedItems:(NSSet *)values;

+ (void) createFeedWithUrl:(NSString *) url
                   success:(void(^)(NSDictionary *data))successBlock
                   failure:(void(^)(NSDictionary *data))failureBlock;

+ (void) requestDefaultFeedsWithSuccess:(void(^)(NSDictionary *data))successBlock
                                failure:(void(^)(NSDictionary *data))failureBlock;

+ (void) requestFeedsByName:(NSString *) name
                    success:(void(^)(NSDictionary *data))successBlock
                    failure:(void(^)(NSDictionary *data))failureBlock;

@end
