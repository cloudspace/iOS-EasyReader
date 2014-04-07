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
    [self loadFeedItemWebView];
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
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [controller.webView_feedItem loadRequest:request];
    }
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y >=  CGRectGetHeight(scrollView.frame))
//    {
////        scrollView.scrollEnabled = NO;
////        NSLog(@"Disabling scroll view scrolling");
//    }
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView.contentOffset.y == CGRectGetHeight(scrollView.frame)) {
//        scrollView.scrollEnabled = NO;
//        scrollView.delaysContentTouches = NO;
//        [controller.scrollView_vertical becomeFirstResponder];
//        NSLog(@"stop delaying touches");
//        //[controller.webView_feedItem becomeFirstResponder];
//    }
//    else
//    {
//        NSLog(@"start delaying touches");
//        [controller.webView_feedItem becomeFirstResponder];
//        scrollView.delaysContentTouches = YES;
//    }
//}



- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if (scrollView.contentOffset.y == CGRectGetHeight(scrollView.frame)) {
//        scrollView.delaysContentTouches = NO;
//        NSLog(@"stop delaying touches");
//        //[controller.webView_feedItem becomeFirstResponder];
//    }
//    else
//    {
//        NSLog(@"start delaying touches");
//        scrollView.delaysContentTouches = YES;
//    }
}

@end
