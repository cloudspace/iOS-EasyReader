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

- (NSString *)timeAgo
{
    return [self.updatedAt timeAgo];
}

- (NSString *)headline
{
    return[NSString stringWithFormat:@"%@ \u00b7 %@",[self feedName],[self timeAgo]];
}

+ (void) createFeedItemsFromRoute:(NSString *)routeName
                       withParams:(NSDictionary*)params
                          success:(void(^)(NSDictionary *data))successBlock
                          failure:(void(^)(NSDictionary *data))failureBlock
{
  [[CSResponsiveApiRequestor sharedRequestor] requestRoute:routeName
                                                withParams:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseData){
                                                     for(NSDictionary *data in responseData[@"feed_items"]) {
                                                       for( Feed *currentFeed in [[User current] feeds] ){
                                                         if( data[@"feed_id"] == currentFeed.id ){
                                                           [currentFeed addFeedItemsObject:[FeedItem createOrUpdateFirstFromAPIData:data]];
                                                         }
                                                       }
                                                     }

                                                     [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
                                                     if(successBlock) successBlock(responseData);
                                                   }failure:^(AFHTTPRequestOperation *operation, id responseData){
                                                     if(failureBlock) failureBlock(responseData);
                                                   }];
  
}
@end
