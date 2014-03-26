//
//  APIRoute.h
//
//  Created by Joseph Lorich on 3/19/14.
//  Copyright (c) 2014 Joseph Lorich.
//  Contributions by Cloudspace (http://www.cloudspace.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>

/// Signifies http request method types
typedef NS_ENUM(NSInteger, APIRequestMethod) {
    
    /// Signifies an http GET API request
    kAPIRequestMethodGET,
    
    /// Signifies an http POST request
    kAPIRequestMethodPOST,
    
    /// Signifies an http PUT request
    kAPIRequestMethodPUT,
    
    /// Signifies an http PATCH request
    kAPIRequestMethodPATCH,
    
    /// Signifies an http DELETE request
    kAPIRequestMethodDELETE,
    
    /// Signifies an http HEAD request
    kAPIRequestMethodHEAD
};


/**
 * An API Route
 */
@interface APIRoute : NSObject


#pragma mark - Properties

/// The string representation for the url for this route
@property (nonatomic, readonly) NSString *path;

/// The request method for this route
@property (nonatomic, readonly) APIRequestMethod requestMethod;

/// The request method string for this route
@property (nonatomic, readonly) NSString *requestMethodString;


#pragma mark - Initializers

/**
 * Initializes a new CSApiRoute
 *
 * @param path the path for this URL
 * @param requestMethod the request method for this route
 */
- (id)initWithPath:(NSString *)path requestMethod:(APIRequestMethod)requestMethod;


/**
 * Builds a URL String for a given set of parameters
 *
 * @param parameters The URL Parameters
 */
- (NSString *)pathStringForParameters:(NSDictionary *)parameters;

@end
