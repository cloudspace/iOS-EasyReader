//
//  User.m
//  
//
//  Created by Michael Beattie on 3/11/14.
//
//

#import "User.h"
#import "Feed.h"


@implementation User

@dynamic feeds;
@dynamic feedItems;

/**
 * Gathers all the items in a users feeds
 */
- (NSSet *)feedItems
{
    NSMutableSet *feedItems = [[NSMutableSet alloc] init];

    for (Feed *feed in self.feeds)
    {
        [feedItems setByAddingObjectsFromSet:feed.feedItems];
    }
    
    return feedItems;
}

/**
 * Returns the current user.
 * Creates a new one if none exist.
 */
+ (User *)current
{
  NSArray *users = [User findAll];
  
  if ([users count] > 0)
  {
    return users[0];
  }
  else
  {
    User *user = [User createEntity];
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    return user;
  }
}

@end
