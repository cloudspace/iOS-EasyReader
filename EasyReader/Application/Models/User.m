//
//  User.m
//  
//
//  Created by Michael Beattie on 3/11/14.
//
//

#import "User.h"
#import "Feed.h"



#pragma mark - Static declarations


/// The shared instance
static User *sharedInstance = nil;

@implementation User

@dynamic feeds;
@dynamic feedItems;

#pragma mark - Public Methods

+ (User *) current
{
    @synchronized(self)
    {
        if (!sharedInstance)
        {
            NSArray *users = [User MR_findAll];
            
            if ([users count] > 0)
            {
                sharedInstance = [users firstObject];
            }
            else
            {
                sharedInstance = [User MR_createEntity];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }
        }
        
        return sharedInstance;
    }
}

+ (void) setCurrent:(User *)user {
    @synchronized(self) {
        sharedInstance = user;
    }
}


/**
 * Gathers all the items in a users feeds
 */
- (NSSet *)feedItems
{
    NSMutableSet *feedItems = [[NSMutableSet alloc] init];

    for (Feed *feed in self.feeds)
    {
        [feedItems addObjectsFromArray:[feed.feedItems allObjects]];
    }
    
    return feedItems;
}

- (BOOL)hasFeedWithURL:(NSString *)url
{
    for (Feed *feed in self.feeds) {
        if ([feed.url isEqualToString:url]) {
            return YES;
        }
    }
    return NO;
}


@end
