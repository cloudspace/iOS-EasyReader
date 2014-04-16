//
//  CSHomePageControlDataSource.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRHomePageControlDataSource.h"
#import "EZRHomeViewController.h"
#import "EZRCurrentFeedsProvider.h"

@implementation EZRHomePageControlDataSource

- (NSInteger)numberOfPagesForPageControl
{
    return [[EZRCurrentFeedsProvider shared].feedItems count];
}

@end
