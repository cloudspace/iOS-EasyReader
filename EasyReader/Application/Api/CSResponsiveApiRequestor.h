//
//  CSResponsiveApiRequestor.h
//  EasyReader
//
//  Created by Jeremiah Hemphill on 3/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSResponsiveApiRequestor : NSObject

+ (CSResponsiveApiRequestor *) sharedRequestor;

- (void) requestRoute:(NSString *)routeName
           withParams:(NSDictionary*)params
              success:(void(^)())successBlock
              failure:(void(^)())failureBlock;

@property NSDictionary *routes;

- (NSString *) buildUrlByPath:(NSString *) path;

@end
