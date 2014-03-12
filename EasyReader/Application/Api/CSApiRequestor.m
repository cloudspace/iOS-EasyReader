//
//  CSApiRequestor.m
//  EasyReader
//
//  Created by Jeremiah Hemphill on 3/12/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSApiRequestor.h"

@implementation CSApiRequestor

- (void) requestEndpointResponse:(NSString *) path
                      withMethod:(NSString *) method
                      withParams:(NSDictionary *) params
                         success:(void(^)(AFHTTPRequestOperation *operation, id responseObject)) successBlock
                         failure:(void(^)(AFHTTPRequestOperation *operation, id responseObject)) failureBlock
{
  NSDictionary *data;
  if([method isEqualToString:@"GET"]) {
    data = [self getRequest:path withParams:params];
  } else if([method isEqualToString:@"POST"]) {
    data = [self postRequest:path withParams:params];
  } else {
    data = @{};
  }
}

- (NSDictionary *) getRequest:(NSString *) path withParams:(NSDictionary *) params
{
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    [manager GET:@"http://example.com/resources.json" paramete  rs:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
  return @{};
}

- (NSDictionary *) postRequest:(NSString *) path withParams:(NSDictionary *) params
{
    return @{};
}
@end
