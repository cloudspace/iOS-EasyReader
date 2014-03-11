//
//  Feed.h
//  
//
//  Created by Michael Beattie on 3/11/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FeedItem, User;

@interface Feed : NSManagedObject

@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * externalID;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSSet *feedItems;
@end

@interface Feed (CoreDataGeneratedAccessors)

- (void)addFeedItemsObject:(FeedItem *)value;
- (void)removeFeedItemsObject:(FeedItem *)value;
- (void)addFeedItems:(NSSet *)values;
- (void)removeFeedItems:(NSSet *)values;

@end
