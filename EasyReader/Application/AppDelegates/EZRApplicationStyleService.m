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
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:43/255.0 green:120/255.0 blue:176/255.0 alpha:1.0]];
    [[UISearchBar appearance]     setTintColor:[UIColor colorWithRed:43/255.0 green:120/255.0 blue:176/255.0 alpha:1.0]];
    [[UIToolbar appearance]       setTintColor:[UIColor colorWithRed:43/255.0 green:120/255.0 blue:176/255.0 alpha:1.0]];
        
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSForegroundColorAttributeName,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0], NSShadowAttributeName,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], NSShadowAttributeName,
      [UIFont fontWithName:@"Avenir-Medium" size:17.0], NSFontAttributeName,
      nil]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

@end
