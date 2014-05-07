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


    [[APIClient shared] requestRoute:@"feedCreate"
                          parameters:params
                             success:
     ^(id responseObject, NSInteger httpStatus) {
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
    
    for ( NSDictionary *data in responseData[@"feeds"] ){
        Feed *feed = [Feed createOrUpdateFirstFromAPIData:data];
        
        if (![currentUser.feeds containsObject:feed]) {
          [currentUser addFeedsObject:feed];
        }
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void) purgeOldFeedItems
{
    // Get the number of feed items to remove if there are more than 10
    NSInteger numberOfFeedItemsToRemove = [self.feedItems count] > 10 ? [self.feedItems count] - 10 : 0;
    
    /** 
     * Query and create an array of the oldest feed items from the database
     * Limit the query to only the amount of feed items needed to be removed
     */
    if (numberOfFeedItemsToRemove) {
        NSPredicate *feedPredicate = [NSPredicate predicateWithFormat:@"feed = %@", self];
        NSFetchRequest *fetchFeedItemsToRemove = [FeedItem MR_requestAllSortedBy:@"updatedAt" ascending:YES withPredicate:feedPredicate];
        
        [fetchFeedItemsToRemove setFetchLimit:numberOfFeedItemsToRemove];
        
        NSArray *feedItemsToRemove = [FeedItem MR_executeFetchRequest:fetchFeedItemsToRemove];
        
        [self removeFeedItems:[NSSet setWithArray:feedItemsToRemove]];
        
        for (FeedItem *item in feedItemsToRemove)
        {
            [item MR_deleteEntity];
            
        }
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

@end
