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

#import "AKRouter.h"

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
        
        #ifdef MOCKED
            sharedInstance = [[CSFakedDataRequestor alloc] init];
        #else
            sharedInstance = [[CSResponsiveApiRequestor alloc] init];
        #endif
    });
    return sharedInstance;
}


- (void) requestRoute:(NSString *)routeName
           withParams:(NSDictionary *)params
              success:(void(^)())successBlock
              failure:(void(^)())failureBlock
{
    
    AKRoute *route = [[AKRouter shared] routeForName:routeName];
    NSString *fullUrl = [[[AKRouter shared] urlFor:routeName params:params] absoluteString];
    
    NSDictionary *data;
    
    switch (route.requestMethod)
    {
        case kAKRequestMethodGET:
            data = [self getRequest:fullUrl withParams:params];
            break;
        case kAKRequestMethodPOST:
            data = [self postRequest:fullUrl withParams:params];
            break;
        default:
            data = @{};
    }
    
    if (successBlock) successBlock(nil, data);
}

- (NSDictionary *) getRequest:(NSString *) path withParams:(NSDictionary *) params
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    return @{};
}

- (NSDictionary *) postRequest:(NSString *) path withParams:(NSDictionary *) params
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    return @{};
}

@end