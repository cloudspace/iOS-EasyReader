//
//  CSResponsiveApiParser.m
//  EasyReader
//
//  Created by Jeremiah Hemphill on 3/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSResponsiveApiRouter.h"
#import "CSResponsiveApiRequestor.h"
#import "CSFakedDataRequestor.h"
#import "FeedItem.h"
#import "Feed.h"

@implementation CSResponsiveApiRouter
{
  NSNumber *itemFeedsNum;
}

@synthesize requestor;

static dispatch_once_t pred;
static CSResponsiveApiRouter *sharedInstance = nil;

typedef void (^CallbackBlock)(AFHTTPRequestOperation *operation, id responseObject);

+ (CSResponsiveApiRouter *) sharedRouter
{
    dispatch_once(&pred, ^{
        if (sharedInstance != nil) {
            return;
        }
        sharedInstance = [[CSResponsiveApiRouter alloc] init];
        //todo: replace this line with code that checks the environment and sets the correct requestor
        sharedInstance.requestor = [[CSFakedDataRequestor alloc] init];
    });
    return sharedInstance;
}

//this should be replaced by the contents of a RKObjectManager routes property
- (NSDictionary *) routes
{
    NSDictionary *routes = @{@"feedDefaults": @{@"path": @"/feeds/defaults",
                                                @"method": @"GET"},
                             @"feedSearch": @{@"path": @"/feeds/search",
                                              @"method": @"GET"},
                             @"feedItems": @{@"path": @"/feed_items",
                                             @"method": @"GET"},
                             @"feedCreate": @{@"path": @"/feeds"}
                             
    };
    return routes;
}

- (void) requestRoute:(NSString *)routeName
           withParams:(NSDictionary *)params
              success:(void(^)())successBlock
              failure:(void(^)())failureBlock
{
  NSDictionary *route = [self routes][routeName];
  NSString *method = route[@"method"];
  NSString *fullUrl = [self buildUrlByPath:route[@"path"]];
  
  itemFeedsNum = params[@"this_is_for_testing"];
  
  [requestor requestEndpointResponse:fullUrl
                          withMethod:method
                          withParams:params
                             success:[self requestSuccessful:successBlock]
                             failure:[self requestSuccessful:failureBlock]
   ];
  
}

- (CallbackBlock) requestSuccessful:(void(^)())successBlock {
  return ^(AFHTTPRequestOperation *operation, id responseObject) {
    //object mapping for feed items, feeds, and bad feed ids
    if([responseObject objectForKey:@"feed_items"]) {
      for(NSDictionary *record in responseObject[@"feed_items"]) {
        for( Feed *currentFeed in [[User current] feeds] ){
          if( record[@"feed_id"] == currentFeed.id ){
            [currentFeed addFeedItemsObject:[FeedItem createOrUpdateFirstFromAPIData:record]];
          }
        }
      }
    }
    if([responseObject objectForKey:@"feeds"]) {
      for(NSDictionary *record in responseObject[@"feeds"]) {
        [[User current] addFeedsObject:[Feed createOrUpdateFirstFromAPIData:record]];
      }
    }
    if([responseObject objectForKey:@"bad_feed_ids"]) {
      NSLog(@"Found bad feed ids in a request.  This feature is not yet supported.");
    }
        
    //save changes
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
 
    //run success block
    if(successBlock) {
      successBlock(operation, responseObject);
    }
  };
}

- (CallbackBlock) requestFailed:(void(^)())failureBlock {
  return ^(AFHTTPRequestOperation *operation, id responseObject) {
    //run failure block
    if(failureBlock) {
      failureBlock(operation, responseObject);
    }
  };
}

//this should be converted into a constant whose value is determined by the environment
- (NSString *) baseUrl
{
  return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"api_url"];
}

//adds the base url onto the given path
- (NSString *) buildUrlByPath:(NSString *) path
{
    NSArray *urlParts = [NSArray arrayWithObjects: [self baseUrl], path, nil];
    return [urlParts componentsJoinedByString:@""];
}

@end