//
//  Feed.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/22/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FeedSort, User;

@interface Feed : NSManagedObject

@property (nonatomic, retain) NSString * iconURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *isActiveFor;
@property (nonatomic, retain) NSSet *users;
@property (nonatomic, retain) NSSet *feedSorts;
@end

@interface Feed (CoreDataGeneratedAccessors)

- (void)addIsActiveForObject:(User *)value;
- (void)removeIsActiveForObject:(User *)value;
- (void)addIsActiveFor:(NSSet *)values;
- (void)removeIsActiveFor:(NSSet *)values;

- (void)addUsersObject:(User *)value;
- (void)removeUsersObject:(User *)value;
- (void)addUsers:(NSSet *)values;
- (void)removeUsers:(NSSet *)values;

- (void)addFeedSortsObject:(FeedSort *)value;
- (void)removeFeedSortsObject:(FeedSort *)value;
- (void)addFeedSorts:(NSSet *)values;
- (void)removeFeedSorts:(NSSet *)values;

@end
