//
//  CSHomePageControlDelegate.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRHomePageControlDelegate.h"
#import "EZRHomeViewController.h"

@implementation EZRHomePageControlDelegate
{
    EZRHomeViewController *controller;
}

- (instancetype)initWithController:(EZRHomeViewController *)homeController
{
    self = [super init];
    
    if (self)
    {
        controller = homeController;
    }
    
    return self;
}

- (void)pageControl:(CSCollectionPageControl *)pageControl didSelectPageAtIndex:(NSInteger)index
{
    
}


@end
