//
//  CSRegisterRoutesService.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSRegisterRoutesService.h"
#import "AKRouter.h"

@implementation CSRegisterRoutesService

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AKRouter shared] registerRoute:@"feedDefaults" path:@"/feeds/default/"  requestMethod:kAKRequestMethodGET];
    [[AKRouter shared] registerRoute:@"feedCreate"   path:@"/feeds/"          requestMethod:kAKRequestMethodPOST];
    [[AKRouter shared] registerRoute:@"feedSearch"   path:@"/feeds/search/"   requestMethod:kAKRequestMethodGET];
    [[AKRouter shared] registerRoute:@"feedItems"    path:@"/feeds/"          requestMethod:kAKRequestMethodGET];

    return YES;
}

@end
