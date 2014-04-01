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

- (id)initWithController:(EZRHomeViewController *)homeController
{
    self = [super init];
    
    if (self)
    {
        controller = homeController;
    }
    
    return self;
}


/**
 * Scroll view delegate method for dragging view up into webview
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)sender {
    // If we are scrolling in the scrollView only not a subclass
    if([sender isMemberOfClass:[UIScrollView class]]) {
        [self loadFeedItemWebView];
    }
}

/**
 * Loads a new
 */
- (void) loadFeedItemWebView
{
    if(currentURL != controller.currentFeedItem.url){
        currentURL = controller.currentFeedItem.url;
        
        // load the url in the webView
        NSURL *url = [NSURL URLWithString:currentURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        
        [controller.webView_feedItem loadRequest:requestObj];
    }

}

@end
