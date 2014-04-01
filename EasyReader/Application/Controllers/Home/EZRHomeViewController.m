//
//  CSFeedCollectionViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRHomeViewController.h"

// Pods
#import <Block-KVO/MTKObserving.h>
#import "MFSideMenu.h"

// Models
#import "FeedItem.h"
#import "Feed.h"
#import "User.h"

#import "UIColor+EZRSharedColorAdditions.h"

#import "EZRFeedItemCell.h"
#import "EZRFeedImageService.h"


#import "EZRHomeFeedObserver.h"
#import "EZRHomeCollectionViewDelegate.h"
#import "EZRHomeScrollViewDelegate.h"
#import "EZRHomePageControlDelegate.h"
#import "EZRHomePageControlDataSource.h"

@implementation EZRHomeViewController
{
    /// The feeds observer
    EZRHomeFeedObserver *feedObserver;
        
    /// The collectionView delegate
    EZRHomeCollectionViewDelegate *collectionViewDelegate;
    
    /// The scroll view delegate
    EZRHomeScrollViewDelegate *scrollViewDelegate;
    
    /// The page control delegate
    EZRHomePageControlDelegate *pageControlDelegate;
    
    /// The page control data source
    EZRHomePageControlDataSource  *pageControlDataSource;
}

#pragma mark - UIViewController Methods

/**
 * Sets up the view and it's objects on load
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _feedItems = [[NSMutableSet alloc] init];

    self.currentUser = [User current];
    
    [self setUpPageControl];
    [self setUpVerticalScrollView];
    [self setUpCollectionView];
    [self setUpWebView];
    [self setupFeedsObserver];
}

/**
 * Sets the vertical scroll view content size on subview layout
 * This is necessary here since autolayout determies the size, and autolayout happens
 * after viewDidLoad
 */
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setVerticalScrollViewContentSize];
}

/**
 * Locks the interface orientation to portrait
 */
-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

/**
 * Tells the calling object that this view controller should not autorotate
 */
-(BOOL)shouldAutorotate {
    return NO;
}


#pragma mark - Setup methods

/**
 * Sets up the page control
 */
- (void) setUpPageControl
{
    [self.pageControl_itemIndicator setBackgroundColor:[UIColor EZR_charcoal]];
    
    pageControlDelegate    = [[EZRHomePageControlDelegate alloc] init];
    pageControlDataSource = [[EZRHomePageControlDataSource alloc] init];
    
    self.pageControl_itemIndicator.delegate = pageControlDelegate;
    self.pageControl_itemIndicator.datasource = pageControlDataSource;

}

/**
 * Sets up vertical scroll view on controller start up
 */
-(void)setUpVerticalScrollView
{
    self.scrollView_vertical.pagingEnabled =YES;
    
    scrollViewDelegate = [[EZRHomeScrollViewDelegate alloc] init];
    self.scrollView_vertical.delegate = scrollViewDelegate;
}

/**
 * Sets the size of the vertical scroll view to be double the frame size
 */
- (void)setVerticalScrollViewContentSize
{
    NSInteger width = self.scrollView_vertical.frame.size.width;
    NSInteger height = self.scrollView_vertical.frame.size.height;
    
    self.scrollView_vertical.contentSize = CGSizeMake(width, height*2);
}

/**
 * Sets up collection view on controller start up
 */
- (void)setUpCollectionView
{
    //    NSArray *feedItems = [FeedItem MR_findAll];
    NSSet *feedItems = _currentUser.feedItems;
    
    _feedCollectionViewDataSource = [[EZRHomeCollectionViewDataSource alloc] initWithFeedItems:feedItems
                                                                           reusableCellIdentifier:@"feedItem"];
    self.collectionView_feedItems.dataSource = _feedCollectionViewDataSource;

    collectionViewDelegate = [[EZRHomeCollectionViewDelegate alloc] init];
    self.collectionView_feedItems.delegate = collectionViewDelegate;
}

/**
 * Sets up collection view on controller start up
 */
-(void)setUpWebView
{
    // Create a new webview and place it below the collectionView
    self.webView_feedItem = [[UIWebView alloc] init];
    NSInteger width = self.webView_feedItem.frame.size.width;
    NSInteger height = self.webView_feedItem.frame.size.height;
    self.webView_feedItem.frame= CGRectMake(0, height, width, height*2);
    [self.webView_feedItem setBackgroundColor:[UIColor blackColor]];
    
    // Add it to the bottom of the scrollView
    [self.scrollView_vertical addSubview:self.webView_feedItem];
}


#pragma mark - Observations

/**
 * Assigns observers for feeds
 */
- (void) setupFeedsObserver
{
    [self observeRelationship:@keypath(self.currentUser.feeds)
                  changeBlock:[feedObserver feedsDidChange]
               insertionBlock:nil
                 removalBlock:nil
             replacementBlock:nil
     ];
}


#pragma mark - IBActions

// Receives left menu link click
- (IBAction)buttonLeftMenu_touchUpInside_goToMenu:(id)sender {
    [[self rootViewController] toggleLeftSideMenuCompletion:^{}];
}

/**
 * Scroll to the currentFeedItem when the feedItems update
 */
- (void)scrollToCurrentFeedItem
{
    NSUInteger index = [_feedCollectionViewDataSource.sortedFeedItems indexOfObject:_currentFeedItem];
    NSIndexPath *indexPath;
    
    // If the current index is greater than the feedItem array
    if (index > [_feedCollectionViewDataSource.sortedFeedItems count]-1){
        // Set the index to the last item in the array
        indexPath = [NSIndexPath indexPathForRow:[_feedCollectionViewDataSource.sortedFeedItems count]-1 inSection:0];
    } else {
        indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    }
    
    [_collectionView_feedItems scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)prefetchImagesNearIndex:(NSInteger)currentPageIndex count:(NSInteger)count
{
    NSInteger feedItemsCount = [_feedCollectionViewDataSource.sortedFeedItems count];
    
    NSInteger beginFetchIndex = currentPageIndex - count > 0 ? currentPageIndex - count : 0;
    NSInteger beforeFetchCount = currentPageIndex - count > 0 ?  count : currentPageIndex - beginFetchIndex;
    NSInteger afterFetchCount = currentPageIndex + count + 1 > feedItemsCount ? feedItemsCount - currentPageIndex : count;
    
    NSRange fetchRange = {beginFetchIndex, beforeFetchCount+afterFetchCount};
    
    NSArray *itemsToPrefetch = [_feedCollectionViewDataSource.sortedFeedItems subarrayWithRange:fetchRange];
    
    [[EZRFeedImageService shared] prefetchImagesForFeedItems:itemsToPrefetch];
    
}

@end


