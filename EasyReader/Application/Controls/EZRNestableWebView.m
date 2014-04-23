//
//  EZRNestableWebView.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRNestableWebView.h"

@implementation EZRNestableWebView


- (void) layoutSubviews {
    [super layoutSubviews];
    [self fixOffsetIfZeroForScrollView:self.scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self fixOffsetIfZeroForScrollView:scrollView];
}

- (void)fixOffsetIfZeroForScrollView:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == 0) {
        scrollView.contentOffset = CGPointMake(0, 1);
    }
}

@end
