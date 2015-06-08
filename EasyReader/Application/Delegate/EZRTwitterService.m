//
//  EZRTwitterService.m
//  EasyReader
//
//  Created by John Li on 6/8/15.
//  Copyright (c) 2015 Cloudspace. All rights reserved.
//

#import "EZRTwitterService.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>

@implementation EZRTwitterService

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Fabric with:@[TwitterKit]];
    return YES;
}
@end
