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
    
    // Purge old feed items for each feed
    for (Feed *feed in currentUser.feeds) {
        [feed purgeOldFeedItems];
    }
}


@end
