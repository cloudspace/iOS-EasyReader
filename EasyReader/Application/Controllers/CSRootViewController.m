//
//  CSRootViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/3/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSRootViewController.h"

#import "CSMenuLeftViewController.h"
#import "CSMenuRightViewController.h"
#import "CSWebScrollViewController.h"

//#import "UIViewController+NibLoader.h"

@interface CSRootViewController ()

@end

@implementation CSRootViewController

/**
 * Creates the menu contorllers and side menu
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  
  if (self) {
    // Create view controller
    UIStoryboard *storyboard_home = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    CSWebScrollViewController *homeVC = [storyboard_home instantiateViewControllerWithIdentifier:@"Home"];
    _viewController_main = homeVC;

    [self setViewControllers:@[_viewController_main]];
  }
  
  return self;
}


/**
 * If the left menu is open, it closes it
 * Otherwise it opens to the left menu
 */
- (void) toggleLeftMenu
{
  if (self.menuContainerViewController.menuState == MFSideMenuStateLeftMenuOpen)
  {
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:^{}];
  
  }
  else
  {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
  }
}


@end
