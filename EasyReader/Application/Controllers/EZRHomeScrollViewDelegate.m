//
//  CSHomeScrollViewDelegate.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRHomeScrollViewDelegate.h"
#import "EZRHomeViewController.h"

@implementation EZRHomeScrollViewDelegate
{
    EZRHomeViewController *controller;
    NSString *currentURL;
}

- (instancetype)initWithController:(EZRHomeViewController *)homeController
{
    self = [super init];
    
    if (self) {
        controller = homeController;
    }
    
    return self;
}

//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y == scrollView.frame.size.height) {
//
//    }
//}

/**
 *
 *
 * @param scrollVsiew the
 */
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == -scrollView.contentInset.top) {
        [self stopScrollingInScrollView:scrollView];
    }
}

/**
 * Stops scrolling inside the given scrollview
 *
 * @param The scroll view
 */
- (void)stopScrollingInScrollView:(UIScrollView *)scrollView {
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
}

@end
