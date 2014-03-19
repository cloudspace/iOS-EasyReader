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
#import "Feed.h"

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
  // Override point for customization after application launch.
  
  // Observe account status in settings!!
  // This is important, if something changes we need to check authentication settingsi
  //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canTweetStatus) name:ACAccountStoreDidChangeNotification object:nil];
  
  //  [self applyStyles];
  
  
  //
  // Set up core data
  //
  [MagicalRecord setupAutoMigratingCoreDataStack];
  
  CSFeedItemUpdater *updater = [[CSFeedItemUpdater alloc]  init];
  [updater start];
  
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


- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Saves changes in the application's managed object context before the application terminates.
  [MagicalRecord cleanUp];
}


@end
