//
//  CSFakedDataRequestor.h
//  EasyReader
//
//  Created by Jeremiah Hemphill on 3/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSResponsiveApiRequestor.h"
#import "AFHTTPRequestOperation.h"

@interface CSFakedDataRequestor : CSResponsiveApiRequestor

@property int requestCounter;

- (void) requestRoute:(NSString *) path
           withParams:(NSDictionary *) params
              success:(void(^)(AFHTTPRequestOperation *operation, id responseObject)) successBlock
              failure:(void(^)(AFHTTPRequestOperation *operation, id responseObject)) failureBlock;
  
@end
