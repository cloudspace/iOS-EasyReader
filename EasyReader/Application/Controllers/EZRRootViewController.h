//
//  CSRootViewController.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/3/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFSideMenu.h"

/**
 * A root view controller
 */
@interface EZRRootViewController : UINavigationController

{
  
}

#pragma mark - Properties
/// The left side swipe menu
@property (nonatomic, retain) UIViewController *viewController_menuLeft;

/// The main controller that sits at the top of the app
@property (nonatomic, retain) UIViewController *viewController_main;


#pragma mark - Methods
/**
 * Toggles the left side menu
 */
- (void) toggleLeftMenu;


@end
