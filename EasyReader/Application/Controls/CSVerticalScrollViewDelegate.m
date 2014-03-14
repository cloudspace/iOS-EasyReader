//
//  CSVerticalScrollViewDelegate.m
//  EasyReader
//
//  Created by Michael Beattie on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSVerticalScrollViewDelegate.h"
#import "CSHorizontalScrollView.h"
#import "CSFeedItemContainerViewController.h"
#import "FeedItem.h"

// View dimensions
static NSInteger HEIGHT;
static NSInteger WIDTH;

@implementation CSVerticalScrollViewDelegate

- (id)initWithScrollView:(UIScrollView *)scrollView
              storyboard:(UIStoryboard *)storyboard
           andIdentifier:(NSString *)identifier
{
    self = [super init];
    if( self ){
        _scrollViewController = scrollView;
        _storyboard = storyboard;
        _currentURL = @"";
        
        _feedItemVC = [_storyboard instantiateViewControllerWithIdentifier:identifier];
        _feedItemArticleVC = [_storyboard instantiateViewControllerWithIdentifier:@"WebArticle"];
        
        // Define view height and width
        WIDTH = _scrollViewController.frame.size.width;
        HEIGHT = _feedItemVC.view.frame.size.height;
        
        _feedItemVC.view.frame= CGRectMake(0, 0, WIDTH, HEIGHT);
        _feedItemArticleVC.view.frame= CGRectMake(0, HEIGHT, WIDTH, HEIGHT*2);
        
        // Set the scrollView large enough to fit both
        // the feedItemScrollViews and
        // the feedItemArticleWebView
        [_scrollViewController addSubview:_feedItemVC.view];
        [_scrollViewController addSubview:_feedItemArticleVC.view];
        _scrollViewController.contentSize = CGSizeMake(WIDTH, HEIGHT*2);
        _scrollViewController.pagingEnabled = YES;
        
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CSHorizontalScrollView *HD = (CSHorizontalScrollView *)_feedItemVC.scrollViewController.delegate;
    FeedItem *currentItem = [HD currentFeedItem];
    if(_currentURL != currentItem.url){
        _currentURL = currentItem.url;
        NSString *fullURL = currentItem.url;
        NSURL *url = [NSURL URLWithString:fullURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [_feedItemArticleVC.articleWebView loadRequest:requestObj];
    }
}

@end