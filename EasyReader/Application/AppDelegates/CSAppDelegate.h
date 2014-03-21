//
//  CSAppDelegate.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOApplicationDelegate.h"


@interface CSAppDelegate : SOApplicationDelegate <UIApplicationDelegate>

/// The main application window

#pragma mark - Properties
@property (strong, nonatomic) UIWindow *window;

@end
