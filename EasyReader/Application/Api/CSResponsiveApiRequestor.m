//
//  CSResponsiveApiRequestor.m
//  EasyReader
//
//  Created by Jeremiah Hemphill on 3/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSResponsiveApiRequestor.h"
#import "CSFakedDataRequestor.h"
#import "AFNetworking.h"
#import "FeedItem.h"
#import "Feed.h"
#import "User.h"

@implementation CSResponsiveApiRequestor

static dispatch_once_t pred;
static CSResponsiveApiRequestor *sharedInstance = nil;

typedef void (^CallbackBlock)(AFHTTPRequestOperation *operation, id responseObject);

+ (CSResponsiveApiRequestor *) sharedRequestor
{
    dispatch_once(&pred, ^{
      if (sharedInstance != nil) {
          return;
      }
     sharedInstance = [[CSFakedDataRequestor alloc] init];
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
  
  NSDictionary *data;
  if( [method isEqualToString:@"GET"] ) {
    data = [self getRequest:fullUrl withParams:params];
  } else if([method isEqualToString:@"POST"]) {
    data = [self postRequest:fullUrl withParams:params];
  } else {
    data = @{};
  }
  
  if (successBlock) successBlock(nil, data);
}

- (NSDictionary *) getRequest:(NSString *) path withParams:(NSDictionary *) params
{
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
  }];
  return @{};
}

- (NSDictionary *) postRequest:(NSString *) path withParams:(NSDictionary *) params
{
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  [manager POST:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
  }];
  return @{};
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


//- (CallbackBlock) requestSuccessful:(void(^)())successBlock {
//  return ^(AFHTTPRequestOperation *operation, id responseObject) {
//    //object mapping for feed items, feeds, and bad feed ids
//    if([responseObject objectForKey:@"feed_items"]) {
//      for(NSDictionary *record in responseObject[@"feed_items"]) {
//        for( Feed *currentFeed in [[User current] feeds] ){
//          if( record[@"feed_id"] == currentFeed.id ){
//            [currentFeed addFeedItemsObject:[FeedItem createOrUpdateFirstFromAPIData:record]];
//          }
//        }
//      }
//    }
//    if([responseObject objectForKey:@"feeds"]) {
//      for(NSDictionary *record in responseObject[@"feeds"]) {
//        [[User current] addFeedsObject:[Feed createOrUpdateFirstFromAPIData:record]];
//      }
//    }
//    if([responseObject objectForKey:@"bad_feed_ids"]) {
//      NSLog(@"Found bad feed ids in a request.  This feature is not yet supported.");
//    }
//    
//    //save changes
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//    
//    //run success block
//    if(successBlock) {
//      successBlock(operation, responseObject);
//    }
//  };
//}
//
//- (CallbackBlock) requestFailed:(void(^)())failureBlock {
//  return ^(AFHTTPRequestOperation *operation, id responseObject) {
//    //run failure block
//    if(failureBlock) {
//      failureBlock(operation, responseObject);
//    }
//  };
//}

@end