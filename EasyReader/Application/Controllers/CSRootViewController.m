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
#import "CSHomeViewController.h"

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
    //[self.view setBackgroundColor:[UIColor blackColor]];
    
    // Create view controller
    _viewController_main      = [CSHomeViewController new];

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
