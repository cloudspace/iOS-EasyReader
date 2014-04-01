//
//  CSHomePageControlDelegate.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSCollectionPageControl.h"

@class EZRHomeViewController;


@interface EZRHomePageControlDelegate : NSObject <CSCollectionPageControlDelegate>

/// The home view controller
@property (nonatomic, strong) EZRHomeViewController *controller;

@end
