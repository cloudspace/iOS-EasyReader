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


#pragma mark - MFSideMenuContainerViewController

/**
 * Category to enable access to the private menuContainerView property
 */
@interface MFSideMenuContainerViewController ()

/// The menu container view
@property (nonatomic, strong) UIView *menuContainerView;

@end


#pragma mark - Root view controller

@implementation EZRRootViewController

/**
 * Creates the menu contorllers and side menu
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        UIStoryboard *storyboard_home;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            storyboard_home = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
        } else {
            storyboard_home = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
        }
        
        EZRHomeViewController *collections = [storyboard_home instantiateViewControllerWithIdentifier:@"Home"];
        _viewController_main = collections;
        
        [self setViewControllers:@[_viewController_main]];
    }
    
    return self;
}

/**
 * Disable the gesture recognizer on the left view controller so that it doesn't interfere with
 * swipe to delete on the feed menu tableview
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MFSideMenuContainerViewController *container = (MFSideMenuContainerViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    for (UIGestureRecognizer *recognizer in container.menuContainerView.gestureRecognizers) {
        [recognizer setEnabled:NO];
    }
}

/**
 * If the left menu is open, it closes it
 * Otherwise it opens to the left menu
 */
- (void) toggleLeftMenu {
    if (self.menuContainerViewController.menuState == MFSideMenuStateLeftMenuOpen) {
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed completion:^{}];
        
    } else {
        [self.menuContainerViewController toggleLeftSideMenuCompletion:^{}];
    }
}

@end
