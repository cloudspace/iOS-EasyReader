//
//  CSHomeScrollViewDelegate.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/1/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRHomeScrollViewDelegate.h"
#import "EZRHomeViewController.h"
#import "EZRFeedItemCollectionView.h"

@interface EZRHomeScrollViewDelegate ()

@property (nonatomic, weak) IBOutlet EZRNestableWebView *webView_feedItem;

@property (nonatomic, weak) IBOutlet EZRFeedItemCollectionView *collectionView_feedItems;

@end

@implementation EZRHomeScrollViewDelegate
{
    NSString *currentURL;
    BOOL dragging;
    CGPoint dragStart;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        dragging = NO;
    }
    
    return self;
}
//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Make scrolling back up to the top feel more natural
    if (scrollView.contentOffset.y == scrollView.frame.size.height) {
        if (self.webView_feedItem.scrollView.contentOffset.y == 0) {
            self.webView_feedItem.scrollView.contentOffset = CGPointMake(0, 1);
        }
    }
    
    MFSideMenuContainerViewController *rootVC =
    (MFSideMenuContainerViewController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    // Prevent collectionview scrolling when shar bar is showing
    if (scrollView.contentOffset.y < 0) {
        rootVC.panMode = MFSideMenuPanModeNone;
        self.collectionView_feedItems.userInteractionEnabled = NO;
    } else {
        self.collectionView_feedItems.userInteractionEnabled = YES;
        rootVC.panMode = MFSideMenuPanModeDefault;
    }
    
    if (scrollView.contentOffset.y >= scrollView.frame.size.height) {
        rootVC.panMode = MFSideMenuPanModeNone;
    }
    
    // Don't allow drags from the share view to go past the base view without a stop
    if (dragging && dragStart.y < 0 && scrollView.contentOffset.y >= 0) {
        scrollView.contentOffset = CGPointMake(0,0);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    dragging = YES;
    dragStart = scrollView.contentOffset;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    dragging = NO;
}

/**
 *
 * @param scrollVsiew the
 */
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == -scrollView.contentInset.top) {
        [self stopScrollingInScrollView:scrollView];
    }
}

/**
 * Stops scrolling inside the given scrollview
 *
 * @param The scroll view
 */
- (void)stopScrollingInScrollView:(UIScrollView *)scrollView {
    [scrollView setContentOffset:scrollView.contentOffset animated:NO];
}

@end
