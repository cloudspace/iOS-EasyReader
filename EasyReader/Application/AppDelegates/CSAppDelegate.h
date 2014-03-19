//
//  CSAppDelegate.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSFeedItemUpdater.h"
#import "CSMenuLeftViewController.h"
#import "MFSideMenu.h"

@class Feed;

@interface CSAppDelegate : UIResponder <UIApplicationDelegate>

#pragma mark - Properties
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) Feed *activeFeed;

@property (strong, nonatomic) MFSideMenuContainerViewController *container;

@end
