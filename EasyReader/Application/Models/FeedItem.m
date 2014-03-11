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
@dynamic externalID;

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
+ (NSString *)convertDateToTimeAgo:(NSString *)updatedAt
{
  // Convert updatedAt into NSDate
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
  NSDate *date = [dateFormat dateFromString: updatedAt];
  
  // Convert NSDate into readable time ago
  NSString *timeAgo = [date timeAgo];
  return timeAgo;
}
@end
