//
//  CSResponsiveApiRouter.h
//  EasyReader
//
//  Created by Jeremiah Hemphill on 3/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSResponsiveApiRequestor.h"
#import "AFHTTPRequestOperation.h"

@interface CSResponsiveApiRouter : NSObject

+ (CSResponsiveApiRouter *) sharedRouter;

@property (nonatomic, retain) id<CSResponsiveApiRequestor> requestor;

- (void) requestRoute:(NSString *)routeName
           withParams:(NSDictionary*)params
              success:(void(^)())successBlock
              failure:(void(^)())failureBlock;

@end
