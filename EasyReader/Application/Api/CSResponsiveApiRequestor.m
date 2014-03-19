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
      #ifdef DEBUG
        sharedInstance = [[CSFakedDataRequestor alloc] init];
      #else
        sharedInstance = [[CSResponsiveApiRequestor alloc] init];
      #endif
    });
    return sharedInstance;
}

- (id)init
{
  self = [super init];
  
  self.routes = @{@"feedDefaults": @{@"path": @"/feeds/defaults",
                                     @"method": @"GET"},
                  @"feedSearch": @{@"path": @"/feeds/search",
                                   @"method": @"GET"},
                  @"feedItems": @{@"path": @"/feed_items",
                                  @"method": @"GET"},
                  @"feedCreate": @{@"path": @"/feeds"}
                  };
  return self;
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

@end