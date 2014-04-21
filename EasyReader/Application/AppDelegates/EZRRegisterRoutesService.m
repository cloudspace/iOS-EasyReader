//
//  CSRegisterRoutesService.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRRegisterRoutesService.h"
#import "APIRouter.h"

@implementation EZRRegisterRoutesService

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[APIRouter shared] registerRoute:@"feedDefaults" path:@"/feeds/default/"  requestMethod:kAPIRequestMethodGET];
    [[APIRouter shared] registerRoute:@"feedCreate"   path:@"/feeds/"          requestMethod:kAPIRequestMethodPOST];
    [[APIRouter shared] registerRoute:@"feedSearch"   path:@"/feeds/search/"   requestMethod:kAPIRequestMethodGET];
    [[APIRouter shared] registerRoute:@"feedItems"    path:@"/feed_items/"     requestMethod:kAPIRequestMethodGET];
    
    return YES;
}

@end
