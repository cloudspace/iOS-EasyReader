//
//  CSResponsiveApiRequestor.h
//  EasyReader
//
//  Created by Jeremiah Hemphill on 3/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"

@protocol CSResponsiveApiRequestor <NSObject>
- (void) requestEndpointResponse:(NSString *) path
                                withMethod:(NSString *) method
                                withParams:(NSDictionary *) params
                                   success:(void(^)(AFHTTPRequestOperation *operation, id responseObject)) successBlock
                                   failure:(void(^)(AFHTTPRequestOperation *operation, id responseObject)) failureBlock;
@end
