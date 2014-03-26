//
//  APIMockedDataClient.m
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

#import "APIMockedDataClient.h"
#import "APIMockRequest.h"
#import "APIMockResponse.h"
#import "APIRouter.h"

@implementation APIMockedDataClient
{
    /// An array of mock requests loaded into the system from json fixtures
    NSMutableArray *_mockRequests;
}

#pragma mark - Public methods

- (void) requestRoute:(NSString*)routeName
           parameters:(NSDictionary *)parameters
              success:(APISuccessBlock)success
              failure:(APIFailureBlock)failure
{
    APIRoute *route = [[APIRouter shared] routeNamed:routeName];
    NSString *path = [route pathStringForParameters:parameters];
    NSString *requestMethod = route.requestMethodString;

    APIMockRequest *request = [self mockRequestForPath:path method:requestMethod parameters:parameters headers:nil];
    APIMockResponse *response = request.response;
    
    if (request)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (response.httpStatus < 400)
            {
                if (success) { success(response.body, response.httpStatus); }
            }
            else
            {
                if (failure) { failure(response.body, response.httpStatus, nil); }
            }
        });
    }
    else
    {
         if (failure) { failure(nil, 0, nil); }
    }
}

   
#pragma mark - Private methods
   
/**
 * Initializes an APIClient instance
 */
- (id) init
{
    self = [super init];
    
    if (self)
    {
        _mockRequests = [[NSMutableArray alloc] init];
        [self loadMockData];
    }
    
    return self;
}


#pragma mark - Request finder


/**
 * Returns a mock request exactly matching the given data.
 * If any argument is nil that search case will be ignored.
 *
 * @param path The path to match
 * @param method The method to match
 * @param parameters The parameters to math
 * @param headers The headers to match
 */

- (APIMockRequest *)mockRequestForPath:(NSString *)path
                                method:(NSString *)method
                            parameters:(NSDictionary *)parameters
                               headers:(NSDictionary *)headers
{
    for (APIMockRequest *request in _mockRequests)
    {
        BOOL pathsMatch = path ? [path isEqualToString:request.path] : YES;
        BOOL methodsMatch = method ? [method isEqualToString:request.method] : YES;
        BOOL parametersMatch = parameters ? [parameters isEqualToDictionary:request.parameters] : YES;
        BOOL headersMatch = headers ? [headers isEqualToDictionary:request.headers] : YES;
        
        if (pathsMatch && methodsMatch && parametersMatch && headersMatch)
        {
            return request;
        }
    }
    
    return nil;
}


#pragma mark - Loading mock data

/**
 * Loads all mock .json files in the fixtures directory
 */
- (void)loadMockData
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSArray *fixturePaths = [mainBundle pathsForResourcesOfType:@"json" inDirectory:nil];
    
    for (NSString *path in fixturePaths)
    {
        [self loadMockDataForFixtureAtPath:path];
    }
}

/**
 * Creates and stores mock data classes for a fixture at the given path
 */
- (void)loadMockDataForFixtureAtPath:(NSString *)path
{
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSError* error = nil;
    NSDictionary *fixtureDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
//    
//    NSURL *url = [NSURL fileURLWithPath:path];
//    NSDictionary *fixtureDictionary = [NSDictionary dictionaryWithContentsOfURL:url];
    
    for (NSString *requestPath in [fixtureDictionary allKeys])
    {
        [self loadMockRequestForPath:requestPath fixtures:fixtureDictionary[requestPath]];
    }
}

/**
 * Loads mock requests into the _mockRequests array for each request at a given path
 *
 * @param requestPath The request path
 * @param fixture The fixture data to generate the requests and responses from
 */
- (void)loadMockRequestForPath:(NSString*)requestPath fixtures:(NSArray*)fixtures
{
    for (NSDictionary *pair in fixtures)
    {
        APIMockRequest *request = [self mockRequestFromFixture:pair[@"request"] withPath:requestPath];
        APIMockResponse *response = [self mockResponseFromFixture:pair[@"response"]];
        
        request.response = response;
        response.request = request;
        
        [_mockRequests addObject:request];
    }
}

/**
 * Builds an APIMockRequest based on the given request data and path
 *
 * @param requestData The request data
 * @param path The request path
 */
- (APIMockRequest *)mockRequestFromFixture:(NSDictionary *)requestData withPath:(NSString *)path
{
    APIMockRequest *request = [[APIMockRequest alloc] init];
    request.path = path;
    request.parameters = requestData[@"parameters"];
    request.method = requestData[@"method"];
    
    return request;
}

/**
 * Builds an APIMockResponse based on the given response data and path
 *
 * @param responseData The response data
 */
- (APIMockResponse *)mockResponseFromFixture:(NSDictionary *)responseData
{
    APIMockResponse *response = [[APIMockResponse alloc] init];
    response.body = responseData[@"body"];
    response.headers = responseData[@"headers"];
    response.httpStatus = [responseData[@"status"] integerValue];
    
    return response;
}



@end
