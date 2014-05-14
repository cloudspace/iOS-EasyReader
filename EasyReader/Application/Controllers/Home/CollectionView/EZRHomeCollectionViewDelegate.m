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

#import "EZRGoogleAnalyticsService.h"

@interface EZRHomeViewController (Additions)

- (void)prefetchImagesNearIndex:(NSInteger)currentPageIndex count:(NSInteger)count;

@end


@interface EZRHomeCollectionViewDelegate ()

@property (nonatomic, weak) IBOutlet EZRHomeViewController *controller;

@property (nonatomic, weak) IBOutlet EZRFeedItemCollectionView *collectionView;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView_vertical;

@end


@implementation EZRHomeCollectionViewDelegate
{
    FeedItem *previousFeedItem;
}


/**
 * Fires when the collection view scrolls
 * Determines the current page index, and if it's changed it sets the appropriate page control
 *
 * @param sender The scroll view calling the delegate methods
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    FeedItem *currentFeedItem = self.collectionView.currentFeedItem;
    NSInteger pageIndex = self.collectionView.currentPageIndex;
    
    if (previousFeedItem != self.collectionView.currentFeedItem) {
        [self.controller resetWebView];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if (self.collectionView.currentFeedItem == currentFeedItem) {
                [self.controller loadURLForFeedItem:currentFeedItem];
            }
        });
        
        [self.controller prefetchImagesNearIndex:pageIndex count:5];
        [self.controller.pageControl_itemIndicator setPageControllerPageAtIndex:pageIndex];
        
        previousFeedItem = currentFeedItem;
    }
}

/**
 * Scrolls the window down when a title is tapped
 */
- (void)didTapHeadlineOfCell:(EZRFeedItemCollectionViewCell *)cell {
    CGPoint lowestPoint = CGPointMake(0, self.scrollView_vertical.contentSize.height - CGRectGetHeight(self.scrollView_vertical.frame));
    [self.scrollView_vertical setContentOffset:lowestPoint animated:YES];
}

@end
