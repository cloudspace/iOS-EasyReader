//
//  CSFeedItemUpdater.m
//  EasyReader
//
//  Created by Jeremiah Hemphill on 3/12/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedItemUpdater.h"
#import "CSResponsiveApiRouter.h"

@implementation CSFeedItemUpdater
{
  CSResponsiveApiRouter *router;
}

- (void) start
{
  router = [CSResponsiveApiRouter sharedRouter];
  [self getFeeds];
  [self getOneWeekOfFeedItems];
  
  NSMethodSignature *mySignature = [CSFeedItemUpdater
                                     instanceMethodSignatureForSelector:@selector(getFiveMinutesOfFeedItems:)];

  NSInvocation *myInvocation = [NSInvocation
                                 invocationWithMethodSignature:mySignature];

  [myInvocation setTarget:self];
  [myInvocation setSelector:@selector(getFiveMinutesOfFeedItems:)];
  
  int interval = 20 * 1;
  [NSTimer scheduledTimerWithTimeInterval:interval invocation:myInvocation repeats:YES];
}


- (void) getFiveMinutesOfFeedItems:(id)sender
{
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *today = [NSDate date];
  
  NSDateComponents *fiveMinutesAgoComponents = [[NSDateComponents alloc] init];
  [fiveMinutesAgoComponents setMinute:-5];
  NSDate *fiveMinutesAgo = [calendar dateByAddingComponents:fiveMinutesAgoComponents toDate:today options:0];
  
  [self getFeedItemsSince:fiveMinutesAgo];
  
  NSLog(@"Invocation ran!");
}


- (void) getOneWeekOfFeedItems
{
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *today = [NSDate date];
  
  NSDateComponents *oneWeekAgoComponents = [[NSDateComponents alloc] init];
  [oneWeekAgoComponents setWeek:-1];
  NSDate *oneWeekAgo = [calendar dateByAddingComponents:oneWeekAgoComponents toDate:today options:0];
  
  [self getFeedItemsSince:oneWeekAgo];
}

//TODO: Remove 'this is for testing' functionality (in CSResponsiveApiRouter as well)
- (void) getFeedItemsSince:(NSDate *)since
{
  NSDictionary *params = @{
                           @"feed_ids": [self userFeeds],
                              @"since": since
                           };
  [router requestRoute:@"feedItems" withParams:params success:nil failure:nil];
}


- (void) getFeeds
{
  NSDictionary *params = @{
                           @"feed_ids": [self userFeeds]
                           };
  [router requestRoute:@"feedDefaults" withParams:params success:nil failure:nil];
  NSLog(@"User should have feeds");
}


- (NSArray *) userFeeds
{
  NSMutableArray *ids = [[NSMutableArray alloc] init];
  for( Feed *feed in [[User current] feeds] ){
    [ids addObject:feed.id];
  }
  return ids;
}

@end
