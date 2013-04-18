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

@interface CSRootViewController ()

@end

@implementation CSRootViewController

/**
 * 
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  
  if (self) {
    //[self.view setBackgroundColor:[UIColor blackColor]];
    
    // Create view controllers
    _viewController_menuLeft  = [CSMenuLeftViewController new];
    _viewController_menuRight = [CSMenuRightViewController new];
    _viewController_main      = [CSHomeViewController new];

    [self setViewControllers:@[_viewController_main]];
    
    _sideMenu = [MFSideMenu menuWithNavigationController:self
                                 leftSideMenuController:_viewController_menuLeft
                                rightSideMenuController:nil];

    _sideMenu.menuStateEventBlock = ^(MFSideMenuStateEvent event) {
      switch (event) {
        case MFSideMenuStateEventMenuWillOpen:
          NSLog(@"asdf");
          // the menu will open
          break;
        case MFSideMenuStateEventMenuDidOpen:
          // the menu finished opening
          break;
        case MFSideMenuStateEventMenuWillClose:
          // the menu will close
          break;
        case MFSideMenuStateEventMenuDidClose:
          // the menu finished closing
          break;
      }
    };
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

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
