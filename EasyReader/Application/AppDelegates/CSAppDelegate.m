//
//  CSAppDelegate.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSAppDelegate.h"

#import "EZRRegisterRoutesService.h"
#import "EZRCoreDataService.h"
#import "EZRFeedUpdateService.h"
#import "EZRApplicationStyleService.h"

#import "CSRootViewController.h"
#import "User.h"


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
    #ifdef DEBUG
        NSDictionary *environment = [NSProcessInfo processInfo].environment;
        NSString *injectBundlePath = environment[@"XCInjectBundle"];
        BOOL unit_testing = [injectBundlePath.pathExtension isEqualToString:@"xctest"];
    
        if (unit_testing) {
            return YES;
        }
    #endif
        
    [self registerService:[EZRCoreDataService shared]];
    [self registerService:[EZRRegisterRoutesService shared]];
    [self registerService:[EZRApplicationStyleService shared]];
    [self registerService:[EZRFeedUpdateService shared]];
    
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
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];

    EZRMenuViewController *leftMenuViewController = (EZRMenuViewController*)[mainStoryBoard instantiateViewControllerWithIdentifier:@"LeftMenu"];
    
    CSRootViewController *rootVC = [[CSRootViewController alloc] init];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:rootVC
                                                    leftMenuViewController:leftMenuViewController
                                                    rightMenuViewController:nil];
    
    self.window.rootViewController = container;
    [self.window makeKeyAndVisible];
    
}


@end
