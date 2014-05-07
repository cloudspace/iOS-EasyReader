//
//  CSHomeScrollViewDelegate.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZRHomeViewController.h"

/**
 * A delegate for the scroll view on the home view controller
 */
@interface EZRHomeScrollViewDelegate : NSObject <UIScrollViewDelegate>

/**
 * Initializes a new scroll view delegate for the given home view controller instance
 *
 * @param homeController The home view controller
 */
- (instancetype)initWithController:(EZRHomeViewController *)homeController;

@end
