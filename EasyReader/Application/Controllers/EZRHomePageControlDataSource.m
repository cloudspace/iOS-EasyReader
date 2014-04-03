//
//  CSHomePageControlDataSource.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRHomePageControlDataSource.h"
#import "EZRHomeViewController.h"

@implementation EZRHomePageControlDataSource
{
    EZRHomeViewController *controller;
}

- (instancetype)initWithController:(EZRHomeViewController *)homeController {
    self = [super init];
    
    if (self) {
        controller = homeController;
    }
    
    return self;
}
- (NSInteger)numberOfPagesForPageControl
{
    return [controller.feedItems count];
}

@end
