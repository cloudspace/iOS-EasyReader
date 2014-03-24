//
//  APIMockResponse.h
//  EasyReader
//
//  Created by Joseph Lorich on 3/24/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APIMockRequest;

/**
 * A mock API Response
 */
@interface APIMockResponse : NSObject


/// The associated request
@property (nonatomic, retain) APIMockRequest *request;

/// The response headers
@property (nonatomic, retain) NSDictionary *headers;

/// The response status
@property NSInteger httpStatus;

/// The response body
@property (nonatomic, retain) id body;


@end
