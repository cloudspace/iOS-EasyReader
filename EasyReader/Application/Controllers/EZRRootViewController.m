//
//  CSRootViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/3/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "EZRRootViewController.h"

#import "EZRMenuViewController.h"
#import "EZRHomeViewController.h"



//#import "UIViewController+NibLoader.h"

@interface EZRRootViewController ()

@end

@implementation EZRRootViewController

/**
 * Creates the menu contorllers and side menu
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  
  if (self) {
    // Create view controller
    UIStoryboard *storyboard_home = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    EZRHomeViewController *collections = [storyboard_home instantiateViewControllerWithIdentifier:@"Home"];
    _viewController_main = collections;

    [self setViewControllers:@[_viewController_main]];
  }
  
  return self;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
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
