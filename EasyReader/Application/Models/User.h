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

@interface User : CSBaseObject

@property (nonatomic, retain) NSSet *feeds;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addFeedsObject:(Feed *)value;
- (void)removeFeedsObject:(Feed *)value;
- (void)addFeeds:(NSSet *)values;
- (void)removeFeeds:(NSSet *)values;

+ (User *)current;

@end
