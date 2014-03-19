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
- (NSString *)feedName
{
  Feed *feed = self.feed;
  return feed.name;
}

- (NSString *)timeAgo
{
    return [self.updatedAt timeAgo];
}

- (NSString *)headline
{
    return[NSString stringWithFormat:@"%@ \u00b7 %@",[self feedName],[self timeAgo]];
}

@end
