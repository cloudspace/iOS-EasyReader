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
#import "User.h"
#import "CSResponsiveApiRequestor.h"
#import "AFHTTPRequestOperation.h"

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

- (NSString *)headline
{
    NSString *timeAgo = [self.updatedAt timeAgo];
    
    return[NSString stringWithFormat:@"%@ \u00b7 %@", self.feed.name, timeAgo];
}

+ (void) requestFeedItemsFromFeeds:(NSSet  *)feeds
                             Since:(NSDate *)startAt
                           success:(void(^)(NSDictionary *data))successBlock
                           failure:(void(^)(NSDictionary *data))failureBlock
{
  NSMutableArray *feedIds = [[NSMutableArray alloc] init];
  for( Feed *feed in feeds ){
    [feedIds addObject:feed.id];
  }
  
  NSDictionary *params = @{
                           @"since": startAt,
                           @"feed_ids": feedIds
                           };
  
  [[CSResponsiveApiRequestor sharedRequestor] requestRoute:@"feedItems"
                                                withParams:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseData){
                                                     [self saveParsedResponseData:responseData];
                                                     if(successBlock) successBlock(responseData);
                                                   }failure:^(AFHTTPRequestOperation *operation, id responseData){
                                                     if(failureBlock) failureBlock(responseData);
                                                   }];
}

+ (void) saveParsedResponseData:(id)responseData
{
  for(NSDictionary *data in responseData[@"feed_items"]) {
    for( Feed *currentFeed in [[User current] feeds] ){
      if( data[@"feed_id"] == currentFeed.id ){
        [currentFeed addFeedItemsObject:[FeedItem createOrUpdateFirstFromAPIData:data]];
      }
    }
  }

  [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}
@end
