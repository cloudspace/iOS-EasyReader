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
    [self registerService:[CSRegisterRoutesService shared]];
    [self registerService:[CSCoreDataService shared]];
    [self registerService:[CSApplicationStyleService shared]];
    [self registerService:[CSFeedUpdateService shared]];
    
    [self invokeServiceMethodWithSelector:@selector(application:didFinishLaunchingWithOptions:) withArgument:&launchOptions];
    
    [self setUpApplicationWindow];
    
    return YES;
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
