//
//  CSHomeCollectionViewDelegate.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRHomeCollectionViewDelegate.h"
#import "EZRHomeViewController.h"

#import "EZRFeedItemCollectionView.h"
#import "CSCollectionPageControl.h"

@interface EZRHomeViewController (Additions)

- (void)prefetchImagesNearIndex:(NSInteger)currentPageIndex count:(NSInteger)count;
- (void)setCurrentFeedItem:(FeedItem *)item;

@end


@implementation EZRHomeCollectionViewDelegate
{
    EZRHomeViewController    *controller;
    EZRFeedItemCollectionView *collectionView;
    NSInteger _currentPageIndex;
}

- (instancetype)initWithController:(EZRHomeViewController *)homeController
{
    self = [super init];
    
    if (self)
    {
        controller        = homeController;
        _currentPageIndex = 0;
    }
    
    return self;
}

/**
 * Fires when the collection view has stopped decelerating
 * Resets the web view if the current feed item has changed
 *
 * @param sender The scroll view calling the delegate methods
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender
{
    // unload the webView if we have moved to a new feedItem
    if(controller.currentFeedItem != controller.collectionView_feedItems.currentFeedItem)
    {
        controller.currentFeedItem = controller.collectionView_feedItems.currentFeedItem;
        [self resetWebView];
    }
}

/**
 * Resets the content of the web view
 */
- (void)resetWebView
{
    NSString *blankHTML = @"<html><head></head><body style=\"background-color: #000000;\"></body></html>";
    [controller.webView_feedItem loadHTMLString:blankHTML
                                        baseURL:nil];
}

/**
 * Fires when the collection view scrolls
 * Determines the current page index, and if it's changed it sets the appropriate page control
 *
 * @param sender The scroll view calling the delegate methods
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = controller.collectionView_feedItems.frame.size.width;
    
    // We add half the page width to the offset to consider the most-centered page to be the current one, not
    // the page currently under the leftmost position of the view
    NSInteger pageIndex = ((scrollView.contentOffset.x + pageWidth/2.0) / pageWidth);
    
    if (_currentPageIndex != pageIndex)
    {
        [self resetWebView];
        
        _currentPageIndex = pageIndex;
        
        [controller prefetchImagesNearIndex:pageIndex count:5];
        [controller.pageControl_itemIndicator setPageControllerPageAtIndex:pageIndex];
        controller.currentFeedItem = controller.sortedFeedItems[pageIndex];
        NSLog(@"%@", controller.currentFeedItem.title);
    }
}

@end
