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

#import "EZRFeedItemCollectionViewCell.h"
#import "EZRFeedImageService.h"

#import "EZRHomeCollectionViewDelegate.h"
#import "EZRHomeScrollViewDelegate.h"
#import "EZRHomePageControlDelegate.h"
#import "EZRHomePageControlDataSource.h"

#import "EZRNestableWebView.h"
#import "EZRHomeWebViewDelegate.h"

#import "EZRCurrentFeedsProvider.h"


#import "CSArrayCollectionViewDataSource.h"


@interface EZRHomeViewController()

@property User *currentUser;


///
@property (nonatomic, strong) EZRCurrentFeedsProvider *currentFeedsProvider;


@end


@implementation EZRHomeViewController
{
    /// The collectionView delegate
    EZRHomeCollectionViewDelegate *collectionViewDelegate;
    
    /// The scroll view delegate
    EZRHomeScrollViewDelegate *scrollViewDelegate;
    
    /// The page control delegate
    EZRHomePageControlDelegate *pageControlDelegate;
    
    /// The page control data source
    EZRHomePageControlDataSource  *pageControlDataSource;
    
    /// The delegate for the web view
    EZRHomeWebViewDelegate *webViewDelegate;
    
    /// The data source for the collection view
    CSArrayCollectionViewDataSource *collectionViewArrayDataSource;
    
    
    /// The flow layout for the collection view
    UICollectionViewFlowLayout *collectionViewLayout;
    
    UIActionSheet *menu;

}

- (FeedItem *)currentFeedItem
{
    return self.collectionView_feedItems.currentFeedItem;
}


- (void)setCurrentPageIndex:(NSInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex;
}


#pragma mark - UIViewController Methods

/**
 * Sets up the view and it's objects on load
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentFeedsProvider = [EZRCurrentFeedsProvider shared];

    [self setUpPageControl];
    [self setUpVerticalScrollView];
    [self setUpCollectionView];
    [self setUpWebView];
    

    
    [self observeRelationship:@keypath(self.currentFeedsProvider.visibleFeedItems) changeBlock:^(EZRCurrentFeedsProvider *provider, NSArray *visibleFeedItems) {
        [self visibleFeedItemsDidChange:provider visibleFeeditems:visibleFeedItems];
    }];
    
    [self observeProperty:@keypath(self.currentFeedsProvider.visibleFeedItems) withBlock:^(__weak id self, id old, id new) {
        NSLog(@"doing stuff");
    }];
//    
//    [self observeObject:self.currentFeedsProvider property:@"visibleFeedItems" withSelector:@selector(visibleFeedItemsDidChange:visibleFeeditems:)];
    
}

/**
 * Sets the vertical scroll view content size on subview layout
 * This is necessary here since autolayout determies the size, and autolayout happens
 * after viewDidLoad
 */
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layOutVerticalScrollView];
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
    pageControlDelegate   = [[EZRHomePageControlDelegate alloc] initWithController:self];
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
    scrollViewDelegate = [[EZRHomeScrollViewDelegate alloc] initWithController:self];
    self.scrollView_vertical.delegate = scrollViewDelegate;
    [self layOutVerticalScrollView];
}

/**
 * Sets the size of the vertical scroll view to be double the frame size
 */
- (void)layOutVerticalScrollView
{
    NSInteger width = CGRectGetWidth(self.scrollView_vertical.frame);
    NSInteger height = CGRectGetHeight(self.scrollView_vertical.frame);
    
    self.scrollView_vertical.contentSize = CGSizeMake(width, height*2);
    self.webView_feedItem.frame = CGRectMake(0, height, width, height);
    collectionViewLayout.itemSize = CGSizeMake(width, height);
}

/**
 * Sets up collection view on controller start up
 */
- (void)setUpCollectionView
{
    collectionViewArrayDataSource = [CSArrayCollectionViewDataSource dataSourceWithArray:self.currentFeedsProvider.feedItems
                                     reusableCellIdentifier:@"feedItem"
                                             configureBlock:^(UICollectionViewCell *cell, id item) {
                                                 ((EZRFeedItemCollectionViewCell *)cell).feedItem = item;
                                             }];
    
    self.collectionView_feedItems.dataSource = collectionViewArrayDataSource;
    
    collectionViewDelegate = [[EZRHomeCollectionViewDelegate alloc] initWithController:self];
    self.collectionView_feedItems.delegate = collectionViewDelegate;
}

/**
 * Sets up collection view on controller start up
 */
-(void)setUpWebView
{
    self.webView_feedItem = [[EZRNestableWebView alloc] init];
    [self.webView_feedItem setBackgroundColor:[UIColor redColor]];
    [self.scrollView_vertical addSubview:self.webView_feedItem];
    
    webViewDelegate = [[EZRHomeWebViewDelegate alloc] initWithController:self];
    
    self.webView_feedItem.scrollView.delegate = webViewDelegate;
    self.webView_feedItem.delegate = webViewDelegate;
}


#pragma mark - Observations

/**
 * Updates the data source when the feed items change
 */
- (void) visibleFeedItemsDidChange:(EZRCurrentFeedsProvider *)currentFeedService visibleFeeditems:(NSArray *)visibleFeedItems {
    collectionViewArrayDataSource.source = visibleFeedItems;
    
    [self.collectionView_feedItems reloadData];
    
    if([visibleFeedItems containsObject:self.currentFeedItem]){
        [self scrollToCurrentFeedItem];
    } else if ([visibleFeedItems count] > 0){
        
    }
    
    NSInteger count = [self.currentFeedsProvider.visibleFeedItems count];
    
    self.pageControl_itemIndicator.numberOfPages = count < 6 ? count : 5;
    [self.pageControl_itemIndicator setPageControllerPageAtIndex:self.currentPageIndex];
    
//    if (_currentPageIndex == 0 && _currentFeedItem) {
        [self prefetchFirstImages];
//    }
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
    
    NSUInteger index = [self.currentFeedsProvider.visibleFeedItems indexOfObject:self.currentFeedItem];
    NSIndexPath *indexPath;
    NSInteger count = [self.currentFeedsProvider.visibleFeedItems count];
    
    // If the current index is greater than the feedItem array
    if (index > count - 1){
        // Set the index to the last item in the array
        indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
    } else {
        indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    }
    
    [_collectionView_feedItems scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

/**
 * Fetches the current feed item image, then prefetches after
 */
- (void)prefetchFirstImages
{
    if (self.currentFeedItem.imageIphoneRetina)
    {
        [[EZRFeedImageService shared] fetchImageAtURLString:self.currentFeedItem.imageIphoneRetina success:^(UIImage *image, UIImage *blurredImage) {
            [self prefetchImagesNearIndex:1 count:2];
        } failure:^{
            
        }];
    }

}
- (void)prefetchImagesNearIndex:(NSInteger)currentPageIndex count:(NSInteger)count
{
    NSInteger feedItemsCount = [self.currentFeedsProvider.feedItems count];
    
    NSInteger beginFetchIndex = currentPageIndex - count > 0 ? currentPageIndex - count : 0;
    NSInteger beforeFetchCount = currentPageIndex - count > 0 ?  count : currentPageIndex - beginFetchIndex;
    NSInteger afterFetchCount = currentPageIndex + count + 1 > feedItemsCount ? feedItemsCount - currentPageIndex : count;
    
    NSRange fetchRange = {beginFetchIndex, beforeFetchCount+afterFetchCount};
    
    NSArray *itemsToPrefetch = [self.currentFeedsProvider.feedItems subarrayWithRange:fetchRange];
    
    [[EZRFeedImageService shared] prefetchImagesForFeedItems:itemsToPrefetch];
    
}

@end


