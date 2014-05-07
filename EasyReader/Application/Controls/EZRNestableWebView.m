//
//  EZRNestableWebView.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRNestableWebView.h"

@implementation EZRNestableWebView
{
    CGPoint lastContentOffset;
    BOOL scrollViewHasScrolled;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        scrollViewHasScrolled = NO;
    }
    
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self fixOffsetIfZeroForScrollView:self.scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    
    BOOL scrollingUp = (scrollViewHasScrolled && scrollView.contentOffset.y < lastContentOffset.y) || scrollView.contentOffset.y <= 0;
    
    if (!scrollingUp) {
        [self fixOffsetIfZeroForScrollView:scrollView];
    }

    scrollViewHasScrolled = YES;
    lastContentOffset = scrollView.contentOffset;
}

- (void)fixOffsetIfZeroForScrollView:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == 0) {
        scrollView.contentOffset = CGPointMake(0, 1);
    }
}

@end
