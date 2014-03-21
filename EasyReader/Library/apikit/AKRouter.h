//
//  AKRouter.h
//  APIKit Router
//
//  Created by Joseph Lorich on 3/19/14.
//  Copyright (c) 2014 Joseph Lorich.
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
#import "AKRoute.h"

/**
 * An interface to create and process named routes for URLs
 */
@interface AKRouter : NSObject


/**
 * Returns a shared singleton router instance
 */
+ (AKRouter *) shared;

/**
 * Registers a new route with the router
 *
 * @param routeName The route name string
 * @param path The path for the route
 * @param requestMethod the Request Method
 */
- (void)registerRoute:(NSString *)routeName path:(NSString *)path requestMethod:(AKRequestMethod)requestMethod;


/**
 * Builds an NSURL Based on the route name and parameters
 *
 * @param routeName the API Route Name
 * @param params paramaters to be used in building the API route
 */
- (NSURL *)urlFor:(NSString *)routeName params:(NSDictionary *)params;

/**
 * Builds an NSString path based on the route name and parameters
 *
 * @param routeName the API Route Name
 * @param params paramaters to be used in building the API route
 */
- (NSString *)pathFor:(NSString *)routeName params:(NSDictionary *)params;

/**
 * Returns the request method for the given route
 *
 * @param routeName the API Route Name
 */
- (AKRequestMethod)methodFor:(NSString *)routeName;

/**
 * Gets the route object for the given route name
 *
 * @param routeName The routes name
 */
- (AKRoute *)routeForName:(NSString*)routeName;

@end
