//
//  APIMockRequest.h
//  EasyReader
//
//  Created by Joseph Lorich on 3/24/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIMockResponse.h"

/**
 * A mock API Request object.  Used to look up mock API Responses
 */
@interface APIMockRequest : NSObject


/// The request path
@property (nonatomic, retain) NSString *path;

/// The request method
@property (nonatomic, retain) NSString *method;

/// The request headers
@property (nonatomic, retain) NSDictionary *headers;

/// The request parameters
@property (nonatomic, retain) NSDictionary *parameters;

/// The response for this request
@property (nonatomic, retain) APIMockResponse *response;


@end
