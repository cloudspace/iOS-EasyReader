//
//  CSFeedUpdateService.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedUpdateService.h"
#import "CSFeedItemUpdater.h"
#import "User.h"
#import "Feed.h"
#import "FeedItem.h"

@implementation CSFeedUpdateService

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CSFeedItemUpdater *updater = [[CSFeedItemUpdater alloc]  init];
    [updater start];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    User *currentUser = [User current];
    
    for (Feed *feed in currentUser.feeds) {
        
        // Limit feed items to 10
        if (feed.feedItems.count > 10) {
            NSMutableArray *sortedFeedItems = [[NSMutableArray alloc] init];
            sortedFeedItems = [self sortFeedItems:feed.feedItems];
            while (sortedFeedItems.count > 10) {
                
                // Delete the oldest feed item
                [self purgeOldestFeedItem:sortedFeedItems];
            }
        }
    }
}

/**
 * Sort feed items by date descending
 */
- (NSMutableArray *)sortFeedItems:(NSSet *)feedItems
{
    NSArray *sortableArray = [NSArray arrayWithArray:[feedItems allObjects]];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"updatedAt"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return [NSMutableArray arrayWithArray:[sortableArray sortedArrayUsingDescriptors:sortDescriptors]];
}

/**
 * Delete the oldest feed item associated with a feed
 */
- (void)purgeOldestFeedItem:(NSMutableArray *)feedItems
{
    FeedItem *toDelete = [feedItems objectAtIndex:feedItems.count-1];
    [toDelete deleteEntity];
    [feedItems removeObjectAtIndex:feedItems.count-1];
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

@end
