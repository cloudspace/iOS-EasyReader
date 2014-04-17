//
//  EZRHomeWebViewDelegate.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRHomeWebViewDelegate.h"
#import "EZRHomeViewController.h"

@implementation EZRHomeWebViewDelegate
{
    EZRHomeViewController *controller;
    
    NJKWebViewProgressView *progressView;
}

- (instancetype)initWithController:(EZRHomeViewController *)homeController
{
    self = [super init];
    
    if (self)
    {
        controller = homeController;
        self.progressDelegate = self;
    }
    
    return self;
}

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (!progressView) {
        progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(controller.webView_feedItem.frame), 5)];
        [controller.webView_feedItem addSubview:progressView];
    }
    
    [progressView setProgress:progress animated:NO];
}

@end
