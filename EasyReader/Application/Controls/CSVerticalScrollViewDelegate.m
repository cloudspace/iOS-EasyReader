//
//  CSVerticalScrollViewDelegate.m
//  EasyReader
//
//  Created by Michael Beattie on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSVerticalScrollViewDelegate.h"

// View dimensions
static NSInteger HEIGHT;
static NSInteger WIDTH;

@implementation CSVerticalScrollViewDelegate

- (id)initWithScrollView:(UIScrollView *)scrollView
{
  self = [super init];
  if( !self ) return nil;
  _scrollViewController = scrollView;
  
  // Define view height and width
  WIDTH = _scrollViewController.frame.size.width;
  HEIGHT = _scrollViewController.frame.size.height;
  
  // Set the scrollView large enough to fit both
  // the feedItemScrollViews and
  // the feedItemArticleWebView
  _scrollViewController.contentSize = CGSizeMake(WIDTH, HEIGHT*2);
  
  return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
  
}

@end