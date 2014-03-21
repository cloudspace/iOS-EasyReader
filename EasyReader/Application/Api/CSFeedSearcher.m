//
//  CSFeedSearcher.m
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedSearcher.h"
#import "Feed.h"

@implementation CSFeedSearcher

/**
 * Returns a set of Feeds and associated FeedItems
 */
- (void)feedsLike:(NSString *)name
{
    [self searchForFeedsLike:name];
}

/**
 * Call to the API that returns feeds similar to user input
 */
- (void)searchForFeedsLike:(NSString *)name
{
    [Feed requestFeedsByName:name
                     success:^(id responseData){
                         NSLog(@"Search for feeds");
                     }
                     failure:^(id responseData){}];
}

@end
