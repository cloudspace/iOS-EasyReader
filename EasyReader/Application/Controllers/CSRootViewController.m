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

#import "MFSideMenu.h"
#import "UINavigationController+MFSideMenu.h"

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
    
    // Create view controllers
    _viewController_menuLeft  = [CSMenuLeftViewController new];
    _viewController_main      = [CSHomeViewController new];

    [self setViewControllers:@[_viewController_main]];
    
    _sideMenu = [MFSideMenu menuWithNavigationController:self
                                 leftSideMenuController:_viewController_menuLeft
                                rightSideMenuController:nil];
    
    
    [self setSideMenu:_sideMenu];
    

  }
  
  return self;
}


/**
 * If the left menu is open, it closes it
 * Otherwise it opens to the left menu
 */
- (void) toggleLeftMenu
{
  if (self.sideMenu.menuState == MFSideMenuStateLeftMenuOpen)
  {
    [self.sideMenu setMenuState:MFSideMenuStateClosed];
  }
  else
  {
    [self.sideMenu setMenuState:MFSideMenuStateLeftMenuOpen];
  }
}

/**
 * If the right menu is open, it closes it
 * Otherwise it opens to the right menu
 */
- (void) toggleRightMenu
{
  if (self.sideMenu.menuState == MFSideMenuStateRightMenuOpen)
  {
    [self.sideMenu setMenuState:MFSideMenuStateClosed];
  }
  else
  {
    [self.sideMenu setMenuState:MFSideMenuStateRightMenuOpen];
  }
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
