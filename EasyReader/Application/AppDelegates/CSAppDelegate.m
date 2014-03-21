//
//  CSAppDelegate.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSAppDelegate.h"
#import "CSRootViewController.h"
#import "CSMenuLeftViewController.h"
#import "CSFeedItemUpdater.h"
#import "CSResponsiveApiRequestor.h"
#import "User.h"

#import "CSRegisterRoutesService.h"
#import "CSCoreDataService.h"
#import "CSFeedUpdateService.h"

@implementation CSAppDelegate


- (void)applyStyles
{
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:43/255.0 green:120/255.0 blue:176/255.0 alpha:1.0]];
    [[UISearchBar appearance]     setTintColor:[UIColor colorWithRed:43/255.0 green:120/255.0 blue:176/255.0 alpha:1.0]];
    [[UIToolbar appearance]       setTintColor:[UIColor colorWithRed:43/255.0 green:120/255.0 blue:176/255.0 alpha:1.0]];
    
    //[[UILabel appearanceWhenContainedIn:[UINavigationBar class], nil] setFont:[UIFont fontWithName:@"Avenir-Medium" size:17.00]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSForegroundColorAttributeName,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0], NSShadowAttributeName,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], NSShadowAttributeName,
      [UIFont fontWithName:@"Avenir-Medium" size:17.0], NSFontAttributeName,
      nil]];
    
    self.window.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self registerService:[CSRegisterRoutesService shared]];
    [self registerService:[CSCoreDataService shared]];
    [self registerService:[CSFeedUpdateService shared]];
    
    [self invokeServiceMethodWithSelector:@selector(application:didFinishLaunchingWithOptions:) withArgument:&launchOptions];



    //
    // Set up root view controller and menu container
    //
    CSMenuLeftViewController *leftMenuViewController = [[CSMenuLeftViewController alloc] init];
    CSRootViewController *rootVC = [[CSRootViewController alloc] init];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:rootVC
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:nil];
    
    self.window.rootViewController = container;
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}





@end
