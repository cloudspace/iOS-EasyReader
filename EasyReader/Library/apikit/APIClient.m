//
//  APIClient.m
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


#import "APIClient.h"
#import "APIMockedDataClient.h"
#import "AFNetworking.h"
#import "APIRouter.h"


#pragma mark - Block definitions

/// An AFNetworking success block
typedef void (^AFSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);

/// An AFNetworking failure block
typedef void (^AFFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);


#pragma mark - Static declarations

/// The shared instance dispatch once predicate
static dispatch_once_t pred;

/// The shared instance
static APIClient *sharedInstance = nil;



#pragma mark - APIClient Implementation

@implementation APIClient
{
    /// The AFNetworking request operation manager used to make requests
    AFHTTPRequestOperationManager *_requestManager;
}


#pragma mark - Public Methods

+ (APIClient *) shared
{
    dispatch_once(&pred, ^{
        if (sharedInstance != nil) {
            return;
        }
        
        #ifdef MOCKED
            sharedInstance = [[APIMockedDataClient alloc] init];
        #else
            sharedInstance = [[APIClient alloc] init];
        #endif
    });
    
    return sharedInstance;
}

- (void) requestRoute:(NSString*)routeName
           parameters:(NSDictionary *)parameters
              success:(APISuccessBlock)success
              failure:(APIFailureBlock)failure
{
    NSString *requestMethodString = [[APIRouter shared] methodStringFor:routeName];
    NSURL *url = [[APIRouter shared] urlFor:routeName parameters:parameters];
    
    NSMutableURLRequest *request = [self requestWithMethod:requestMethodString
                                                       URL:url
                                                parameters:parameters];
    

    AFSuccessBlock afSuccess = [self translateAFSuccessBlock:success];
    AFFailureBlock afFailure = [self translateAFFailureBlock:failure];
    
    AFHTTPRequestOperation *operation = [_requestManager HTTPRequestOperationWithRequest:request
                                                                                 success:afSuccess
                                                                                 failure:afFailure];
    [_requestManager.operationQueue addOperation:operation];
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
        _requestManager = [AFHTTPRequestOperationManager manager];
    }
    
    return self;
}

/**
 * Generates an NSMutableURLRequest from the given paramters
 *
 * @param requestMethodString The request method type
 * @param The absolute URL to send the request to
 * @param parameters The request parameters
 */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)requestMethodString
                                       URL:(NSURL *)url
                                parameters:(NSDictionary *)parameters
{
    AFHTTPRequestSerializer<AFURLRequestSerialization> *requestSerializer = _requestManager.requestSerializer;
    
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:requestMethodString
                                                              URLString:[url absoluteString]
                                                             parameters:parameters];
    
    return request;
}

/**
 * Returns an APISuccessBlock wrapped in an AFNetworking success block
 */
- (AFSuccessBlock) translateAFSuccessBlock:(APISuccessBlock)success
{
    return ^void(AFHTTPRequestOperation *operation, id responseData) {
        if (success)
        {
            success(responseData, operation.response.statusCode);
        }
    };
}

/**
 * Returns an APIFailureBlock wrapped in an AFNetworking failure block
 */
- (AFFailureBlock) translateAFFailureBlock:(APIFailureBlock)failure
{
    return ^void(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure)
        {
            NSInteger httpStatus = 0;
            
            if ([error.domain isEqualToString:@"AFNetworkingErrorDomain"])
            {
                httpStatus = [error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
            }
            
            failure(operation.responseObject, operation.response.statusCode, error);
        }
    };
}

@end
