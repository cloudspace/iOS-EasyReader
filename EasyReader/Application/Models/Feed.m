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


+ (void) createFeedWithUrl:(NSString *) url
                   success:(void(^)(NSDictionary *data))successBlock
                   failure:(void(^)(NSDictionary *data))failureBlock
{
  NSDictionary * params = @{@"url": url};
  
  [[CSResponsiveApiRequestor sharedRequestor] requestRoute:@"feedCreate"
                                                withParams:params
                                                   success:^(AFHTTPRequestOperation *operation, id responseData){
                                                     [self saveParsedResponseData:responseData];
                                                     if(successBlock) successBlock(responseData);
                                                   }failure:failureBlock];
  
}

+ (void) requestDefaultFeedsWithSuccess:(void(^)(NSDictionary *data))successBlock
                                failure:(void(^)(NSDictionary *data))failureBlock

{
  [[CSResponsiveApiRequestor sharedRequestor] requestRoute:@"feedDefaults"
                                                withParams:nil
                                                   success:^(AFHTTPRequestOperation *operation, id responseData){
                                                     [self saveParsedResponseData:responseData];
                                                     if(successBlock) successBlock(responseData);
                                                   }
                                                   failure:failureBlock
  ];
  
}

+ (void) requestFeedsByName:(NSString *) name
                    success:(void(^)(NSDictionary *data))successBlock
                    failure:(void(^)(NSDictionary *data))failureBlock
{
  NSDictionary * params = @{@"name": name};
  
  [[CSResponsiveApiRequestor sharedRequestor] requestRoute:@"feedSearch"
                                                withParams:params
                                                   success:successBlock
                                                   failure:failureBlock
   ];
  
}

+ (void) saveParsedResponseData:(id)responseData
{
  for( NSDictionary *data in responseData[@"feeds"] ){
    [[User current] addFeedsObject:[Feed createOrUpdateFirstFromAPIData:data]];
  }
  [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

@end
