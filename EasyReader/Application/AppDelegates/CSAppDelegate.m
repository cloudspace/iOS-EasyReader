//
//  CSAppDelegate.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSAppDelegate.h"

#import "CSRegisterRoutesService.h"
#import "CSCoreDataService.h"
#import "CSFeedUpdateService.h"
#import "CSApplicationStyleService.h"

#import "CSRootViewController.h"

@implementation CSAppDelegate


/**
 * Sets up services on launch
 * 
 *
 * Do not add anything in here other than registering services
 *
 */
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
  UIStoryboard *storyboard_home = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    
  CSMenuLeftViewController *leftMenuViewController = [storyboard_home instantiateViewControllerWithIdentifier:@"LeftMenu"];
  CSRootViewController *rootVC = [[CSRootViewController alloc] init];
  
  self.container = [MFSideMenuContainerViewController containerWithCenterViewController:rootVC
                                                             leftMenuViewController:leftMenuViewController
                                                            rightMenuViewController:nil];
  
  self.window.rootViewController = self.container;
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

/**
 * Creates and configures the main application window
 */
- (void)setUpApplicationWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    CSMenuLeftViewController *leftMenuViewController = [[CSMenuLeftViewController alloc] init];
    CSRootViewController *rootVC = [[CSRootViewController alloc] init];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:rootVC
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:nil];
    
    self.window.rootViewController = container;
    [self.window makeKeyAndVisible];
    
}


@end
