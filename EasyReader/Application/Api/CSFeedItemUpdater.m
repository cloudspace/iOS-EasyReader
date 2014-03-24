//
//  CSFeedItemUpdater.m
//  EasyReader
//
//  Created by Jeremiah Hemphill on 3/12/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedItemUpdater.h"
#import "FeedItem.h"
#import "Feed.h"
#import "User.h"

@implementation CSFeedItemUpdater

- (void) start
{
    
    if (![self hasSetDefaultFeeds])
    {
        [self loadDefaultFeeds];
    }
    else
    {
        [self requestOneWeekOfFeedItems];
    }
    
    NSMethodSignature *mySignature = [CSFeedItemUpdater
                                      instanceMethodSignatureForSelector:@selector(requestFiveMinutesOfFeedItems:)];
    
    NSInvocation *myInvocation = [NSInvocation
                                  invocationWithMethodSignature:mySignature];
    
    [myInvocation setTarget:self];
    [myInvocation setSelector:@selector(requestFiveMinutesOfFeedItems:)];
    
    int interval = 120 * 1;
    [NSTimer scheduledTimerWithTimeInterval:interval invocation:myInvocation repeats:YES];
}


#pragma mark - Private Methods

- (void) requestFiveMinutesOfFeedItems:(id)sender
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    
    NSDateComponents *fiveMinutesAgoComponents = [[NSDateComponents alloc] init];
    [fiveMinutesAgoComponents setMinute:-5];
    NSDate *fiveMinutesAgo = [calendar dateByAddingComponents:fiveMinutesAgoComponents toDate:today options:0];
    
    [self requestFeedItemsSince:fiveMinutesAgo];
    
    NSLog(@"Invocation ran!");
}


- (void) requestOneWeekOfFeedItems
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    
    NSDateComponents *oneWeekAgoComponents = [[NSDateComponents alloc] init];
    [oneWeekAgoComponents setWeek:-1];
    NSDate *oneWeekAgo = [calendar dateByAddingComponents:oneWeekAgoComponents toDate:today options:0];
    
    [self requestFeedItemsSince:oneWeekAgo];
    
    NSLog(@"Setup Invocation");
}

//TODO: Remove 'this is for testing' functionality (in CSResponsiveApiRouter as well)
- (void) requestFeedItemsSince:(NSDate *)since
{
    [FeedItem requestFeedItemsFromFeeds:[[User current] feeds]
                                  Since:since
                                success:^(id responseData, NSInteger httpStatus){
                                    NSLog(@"Feed Items have been added");
                                }failure:nil
     ];
}


- (void) loadDefaultFeeds
{
    [Feed requestDefaultFeedsWithSuccess:^(id responseObject, NSInteger httpStatus) {
        NSLog(@"Default feeds have been added");
    } failure:^(id responseObject, NSInteger httpStatus, NSError *error) {
        NSLog(@"Default feed load failure");
    }];
}



/**
 * Checks NSUserDefaults for an indicator of whether or not the default feeds have been previously loaded
 */
- (BOOL)hasSetDefaultFeeds
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSNumber *defaultFeedsLoaded = [defaults objectForKey:@"defaultFeedsLoaded"];
    
    if (!defaultFeedsLoaded)
    {
        return NO;
    }
    else
    {
        return [defaultFeedsLoaded boolValue];
    }
}

@end
