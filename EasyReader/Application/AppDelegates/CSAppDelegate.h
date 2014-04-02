//
//  CSAppDelegate.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSMenuLeftViewController.h"
#import "MFSideMenu.h"
#import "SRVApplicationDelegate.h"


/**
 * The main delegate for the application
 */
@interface CSAppDelegate : SRVApplicationDelegate <UIApplicationDelegate>


#pragma mark - Properties

/// The side menu container controller
@property (strong, nonatomic) MFSideMenuContainerViewController *container;


@end
