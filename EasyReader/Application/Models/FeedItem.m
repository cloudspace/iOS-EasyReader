//
//  FeedItem.m
//  
//
//  Created by Michael Beattie on 3/11/14.
//
//

#import "FeedItem.h"
#import "NSDate+TimeAgo.h"
#import "Feed.h"


@implementation FeedItem

@dynamic title;
@dynamic summary;
@dynamic updatedAt;
@dynamic publishedAt;
@dynamic createdAt;
@dynamic image;
@dynamic url;
@dynamic feed;
@dynamic id;

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