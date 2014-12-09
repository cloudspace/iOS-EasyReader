//
//  APIRoute.m
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

#import "APIRoute.h"

@implementation APIRoute
{
    NSString *_path;
    APIRequestMethod _requestMethod;
}

#pragma mark - Public

- (id)initWithPath:(NSString *)path requestMethod:(APIRequestMethod)requestMethod
{
    self = [super init];
    
    if (self)
    {
        _path = path;
        _requestMethod = requestMethod;
    }
    
    return self;
}

- (NSString *)pathStringForParameters:(NSDictionary *)parameters
{
    return [self replaceTokensInPath:_path params:parameters];
}

- (NSString *)requestMethodString
{
    switch (self.requestMethod)
    {
        case kAPIRequestMethodGET:
            return @"GET";
        case kAPIRequestMethodPOST:
            return @"POST";
        case kAPIRequestMethodPUT:
            return @"PUT";
        case kAPIRequestMethodPATCH:
            return @"PATCH";
        case kAPIRequestMethodDELETE:
            return @"DELETE";
        case kAPIRequestMethodHEAD:
            return @"HEAD";
    }
}

#pragma mark - Private


/**
 * Replaces all slug tokens (e.g. ":first_name") in a path with their appropriate param
 *
 * @param urlString the base path to parse
 * @param params the parameters for the URL
 */
- (NSString *)replaceTokensInPath:(NSString*)urlString params:(NSDictionary *)params
{
    NSMutableString *parsedString = [urlString mutableCopy];
    
    for (NSString *param in [params allKeys])
    {
        id value = [params valueForKey:param];
        
		// Check that it conforms to the class, not by string name or we won't work with subclasses or base classes like _NSCFString
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
        {
            NSString *token = [NSString stringWithFormat:@":%@", param];
			NSString *replacement = [value description];
            
			// Replace the token in the mutableString in place
			[parsedString replaceOccurrencesOfString:token withString:replacement options:NSLiteralSearch range:NSMakeRange(0, parsedString.length)];
        }
    }
    
    return parsedString;
}


@end
