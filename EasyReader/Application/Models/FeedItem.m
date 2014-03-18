//
//  FeedItem.m
//  EasyReader
//
//  Created by Jeremiah Hemphill on 3/18/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "FeedItem.h"
#import "Feed.h"
#import "NSDate+TimeAgo.h"


@implementation FeedItem

@dynamic createdAt;
@dynamic id;
@dynamic publishedAt;
@dynamic summary;
@dynamic title;
@dynamic updatedAt;
@dynamic url;
@dynamic feed;
@dynamic images;

/**
 * Get the name of the associated Feed
 */
- (NSString *)getFeedName
{
    Feed *feed = self.feed;
    return feed.name;
}

/**
 * Convert the feedItem updatedAt date into
 * a human readable time ago string
 */
+ (NSString *)convertDateToTimeAgo:(NSDate *)updatedAt
{
    // Convert NSDate into readable time ago
    NSString *timeAgo = [updatedAt timeAgo];
    return timeAgo;
}

@end
