//
//  CSApplicationStyleService.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/21/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRApplicationStyleService.h"

@implementation EZRApplicationStyleService

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UILabel appearanceWhenContainedIn:[UITextField class], nil] setTextColor:[UIColor colorWithWhite:1.0f alpha:0.75f]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

@end
