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
//#import "CSResponsiveApiRequestor.h"
//#import "AFHTTPRequestOperation.h"

#import "APIClient.h"

@implementation Feed


@dynamic icon;
@dynamic name;
@dynamic url;
@dynamic id;
@dynamic user;
@dynamic feedItems;


+ (void) createFeedWithUrl:(NSString *) url
                   success:(APISuccessBlock)successBlock
                   failure:(APIFailureBlock)failureBlock
{
    NSDictionary * params = @{@"url": url};


    [[self client] requestRoute:@"feedCreate"
                      parameters:params
                        success:^(id responseObject, NSInteger httpStatus) {
                            [self saveParsedResponseData:responseObject];
                            if(successBlock) successBlock(responseObject, httpStatus);
                        }
                        failure:failureBlock];
}

+ (void) requestDefaultFeedsWithSuccess:(APISuccessBlock)successBlock
                                failure:(APIFailureBlock)failureBlock

{
    [[self client] requestRoute:@"feedDefaults"
                     parameters:nil
                        success:^(id responseObject, NSInteger httpStatus) {
                            NSLog(@"FEED COUNT %ld", (long)[[[User current] feeds] count]);
                            [self saveParsedResponseData:responseObject];
                            if(successBlock) successBlock(responseObject, httpStatus);
                        }
                        failure:failureBlock];
}

+ (void) requestFeedsByName:(NSString *) name
                    success:(APISuccessBlock)successBlock
                    failure:(APIFailureBlock)failureBlock
{
    NSDictionary * params = @{@"name": name};
    
    [[self client] requestRoute:@"feedSearch"
                     parameters:params
                        success:successBlock
                        failure:failureBlock];
}

+ (void) saveParsedResponseData:(id)responseData
{
    User *currentUser = [User current];
    
    for( NSDictionary *data in responseData[@"feeds"] ){
        [currentUser addFeedsObject:[Feed createOrUpdateFirstFromAPIData:data]];
    }
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

@end
