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
- (void)setCurrentPageIndex:(NSInteger)index;

@end


@implementation EZRHomeCollectionViewDelegate
{
    EZRHomeViewController    *controller;
    EZRFeedItemCollectionView *collectionView;
    FeedItem *previousFeedItem;
}

- (instancetype)initWithController:(EZRHomeViewController *)homeController
{
    self = [super init];
    
    if (self)
    {
        controller     = homeController;
        collectionView = homeController.collectionView_feedItems;
    }
    
    return self;
}

/**
 * Fires when the collection view scrolls
 * Determines the current page index, and if it's changed it sets the appropriate page control
 *
 * @param sender The scroll view calling the delegate methods
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    FeedItem *currentFeedItem = collectionView.currentFeedItem;
    NSInteger pageIndex = collectionView.currentPageIndex;
    
    if (previousFeedItem != collectionView.currentFeedItem) {
        [controller resetWebView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (collectionView.currentFeedItem == currentFeedItem) {
                [controller loadURLForFeedItem:currentFeedItem];
            }
        });
        
        [controller prefetchImagesNearIndex:pageIndex count:5];
        [controller.pageControl_itemIndicator setPageControllerPageAtIndex:pageIndex];
        
        previousFeedItem = currentFeedItem;
    }
}

/**
 * Scrolls the window down when a title is tapped
 */
- (void)didTapHeadlineOfCell:(EZRFeedItemCollectionViewCell *)cell {
    CGPoint lowestPoint = CGPointMake(0, controller.scrollView_vertical.contentSize.height - CGRectGetHeight(controller.scrollView_vertical.frame));
    [controller.scrollView_vertical setContentOffset:lowestPoint animated:YES];
}

@end
