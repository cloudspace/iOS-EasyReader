//
//  CSBaseViewController.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSBaseViewController : UIViewController
{
  bool _shouldSetViewFrame;
}

#pragma mark - Properties
@property (nonatomic)         BOOL   hasNavigationBar;   ///< Whether or not the navigation bar should be shown
@property (readonly, retain)  id     rootViewController; ///< A reference to the root view controller for the application
@property (nonatomic, retain) UIView *view;

@end
