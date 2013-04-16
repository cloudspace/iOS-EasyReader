//
//  CSBaseViewController.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSRootViewController;
@interface CSBaseViewController : UIViewController


#pragma mark - Properties
@property (nonatomic)        BOOL hasNavigationBar;                    ///< Whether or not the navigation bar shoudl be shown
@property (readonly, retain) CSRootViewController *rootViewController; ///< The root view controller for the project

@end
