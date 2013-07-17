//
//  CSRootViewController.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/3/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MFSideMenu;

/**
 * A root view controller
 */
@interface CSRootViewController : UINavigationController

{
  
}

#pragma mark - Properties
/// The left side swipe menu
@property (nonatomic, retain) UIViewController *viewController_menuLeft;

/// The main controller that sits at the top of the app
@property (nonatomic, retain) UIViewController *viewController_main;

/// The main controller that sits at the top of the app
@property (nonatomic, retain) MFSideMenu *sideMenu;


#pragma mark - Methods
/**
 * Toggles the left side menu
 */
- (void) toggleLeftMenu;


@end
