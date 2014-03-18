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

- (NSString *)getTimeAgo
{
    return [self.updatedAt timeAgo];
}

- (NSString *)getHeadline
{
    return[NSString stringWithFormat:@"%@ \u00b7 %@",[self getFeedName],[self getTimeAgo]];
}

@end
