//
//  APIRouter.m
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

#import "APIRouter.h"

static dispatch_once_t pred;
static APIRouter *shared = nil;

@implementation APIRouter
{
    /// Internal route storage dictionary
    NSMutableDictionary *_routes;
    
    /// The base API URL
    NSURL *_baseURL;
    
    /// The base API Path
    NSString *_basePath;
}

+ (APIRouter *)shared
{
    dispatch_once(&pred, ^{
        // Ensure we don't overwrite a manually set client
        if (shared != nil) return;
        
        // Load API configuration data from the info plist
        NSBundle *bundle = [NSBundle mainBundle];
        
        NSString *apiHost  = [bundle objectForInfoDictionaryKey:@"ApiHost"];
        NSString *basePath  = [bundle objectForInfoDictionaryKey:@"ApiBasePath"];
        
        shared = [[APIRouter alloc] initWithAPIHost:apiHost basePath:basePath];
    });
    
    return shared;
}

- (id)initWithAPIHost:(NSString *)apiHost basePath:(NSString*)basePath
{
    self = [super init];
    
    if (self)
    {
        _routes = [[NSMutableDictionary alloc] init];
        _baseURL   = [NSURL URLWithString:apiHost];
        _basePath = basePath;
    }
    
    return self;
}

- (void)registerRoute:(NSString *)routeName path:(NSString *)path requestMethod:(APIRequestMethod)requestMethod
{
    if ([[_routes allKeys] containsObject:routeName])
    {
        [NSException raise:@"Route already exists" format:@"The route named %@ already is registered", routeName];
        return;
    }
    
    APIRoute *route = [[APIRoute alloc] initWithPath:path requestMethod:requestMethod];
    
    [_routes setValue:route forKey:routeName];
}

- (NSURL *)urlFor:(NSString *)routeName parameters:(NSDictionary *)params
{
    NSString *path = [self pathFor:routeName params:params];
    
    if (!path)
    {
        return nil;
    }
    
    return [NSURL URLWithString:path relativeToURL:_baseURL];
}

- (NSString *)pathFor:(NSString *)routeName params:(NSDictionary *)params
{
    APIRoute *route = [self routeNamed:routeName];
    NSString *pathString = [route pathStringForParameters:params];

   return [NSString stringWithFormat:@"%@/%@",
          [self stripTrainingSlashes:_basePath],
           [self stripLeadingSlashes:pathString]];
}

- (APIRequestMethod)methodFor:(NSString *)routeName
{
    APIRoute *route = [self routeNamed:routeName];
    
    return [route requestMethod];
}

- (NSString *)methodStringFor:(NSString *)routeName
{
    APIRoute *route = [self routeNamed:routeName];
    return route.requestMethodString;
}

- (APIRoute *)routeNamed:(NSString *)routeName
{
    return [_routes valueForKey:routeName];
}


#pragma mark - Private Methods

/**
 * Strips any trailing '/' from the end of a string
 *
 * This is used to help parse out paths
 */
- (NSString *)stripTrainingSlashes:(NSString *)string
{
    NSInteger stringLength = [string length];
    
    if ([string characterAtIndex:stringLength - 1] == '/')
    {
        return [self stripTrainingSlashes:[string substringWithRange:NSMakeRange(0, stringLength - 1)]];
    }
    else
    {
        return string;
    }
}

/**
 * Strips any leading '/' from the beginning of a string
 *
 * This is used to help parse out paths
 */
- (NSString *)stripLeadingSlashes:(NSString *)string
{
    if ([string characterAtIndex:0] == '/')
    {
        NSInteger stringLength = [string length];
        return [self stripLeadingSlashes:[string substringWithRange:NSMakeRange(1, stringLength-1)]];
    }
    else
    {
        return string;
    }
}


@end
