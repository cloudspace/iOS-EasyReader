//
//  CSHomeScrollViewDelegate.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZRHomeViewController.h"

@interface EZRHomeScrollViewDelegate : NSObject <UIScrollViewDelegate>


- (instancetype)initWithController:(EZRHomeViewController *)homeController;

@end
