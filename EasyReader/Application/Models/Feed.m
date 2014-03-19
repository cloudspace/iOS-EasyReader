//
//  Feed.m
//  
//
//  Created by Michael Beattie on 3/11/14.
//
//

#import "Feed.h"
#import "FeedItem.h"
#import "User.h"
#import "CSResponsiveApiRequestor.h"
#import "AFHTTPRequestOperation.h"

@implementation Feed
{
  CSResponsiveApiRequestor *requestor;
}

@dynamic icon;
@dynamic name;
@dynamic url;
@dynamic id;
@dynamic user;
@dynamic feedItems;


+ (void) createFeedsFromRoute:(NSString *)routeName
                   withParams:(NSDictionary*)params
                      success:(void(^)(NSDictionary *data))successBlock
                      failure:(void(^)(NSDictionary *data))failureBlock
{
  [[CSResponsiveApiRequestor sharedRequestor] requestRoute:routeName
                                                withParams:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseData){
                                                     for( NSDictionary *data in responseData[@"feeds"] ){
                                                       [[User current] addFeedsObject:[Feed createOrUpdateFirstFromAPIData:data]];
                                                     }
                                                     [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
                                                     if(successBlock) successBlock(responseData);
                                                   }failure:^(AFHTTPRequestOperation *operation, id responseData){
                                                     if(failureBlock) failureBlock(responseData);
                                                   }];
  
}

@end
