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

#import "EZRHomeCollectionViewDelegate.h"
#import "EZRHomeScrollViewDelegate.h"
#import "EZRHomePageControlDelegate.h"
#import "EZRHomePageControlDataSource.h"

#import "EZRNestableWebView.h"
#import "EZRHomeWebViewDelegate.h"

@interface EZRHomeViewController()

@property User *currentUser;

/// Feed items on user
@property (nonatomic, strong) NSMutableSet *feedItems;



@end


@implementation EZRHomeViewController
{
    /// The collectionView delegate
    EZRHomeCollectionViewDelegate *collectionViewDelegate;
    
    /// The collectionView data source
    EZRHomeCollectionViewDataSource *collectionViewDataSource;
    
    /// The scroll view delegate
    EZRHomeScrollViewDelegate *scrollViewDelegate;
    
    /// The page control delegate
    EZRHomePageControlDelegate *pageControlDelegate;
    
    /// The page control data source
    EZRHomePageControlDataSource  *pageControlDataSource;
    
    /// The delegate for the web view
    EZRHomeWebViewDelegate *webViewDelegate;
    
    /// The flow layout for the collection view
    UICollectionViewFlowLayout *collectionViewLayout;

}

- (void)setCurrentFeedItem:(FeedItem *)currentFeedItem
{
    _currentFeedItem = currentFeedItem;
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex;
}

- (void)setFeedItems:(NSMutableSet *)feedItems
{
    _feedItems = feedItems;
    
    if (collectionViewDataSource)
    {
      collectionViewDataSource.feedItems = feedItems;
      _sortedFeedItems = collectionViewDataSource.sortedFeedItems;
    }
}

#pragma mark - UIViewController Methods

/**
 * Sets up the view and it's objects on load
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentUser = [User current];
    self.feedItems = [self.currentUser.feedItems mutableCopy];
    
    [self setUpPageControl];
    [self setUpVerticalScrollView];
    [self setUpCollectionView];
    [self setUpWebView];
    [self setupFeedsObserver];
    
    if ([self.feedItems count] > 0) {
      [self.collectionView_feedItems scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self layOutVerticalScrollView];
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
//    [self.pageControl_itemIndicator setBackgroundColor:[UIColor EZR_charcoal]];
    
    pageControlDelegate    = [[EZRHomePageControlDelegate alloc] initWithController:self];
    pageControlDataSource = [[EZRHomePageControlDataSource alloc] initWithController:self];
    
    self.pageControl_itemIndicator.delegate = pageControlDelegate;
    self.pageControl_itemIndicator.datasource = pageControlDataSource;
}

/**
 * Sets up vertical scroll view on controller start up
 */
-(void)setUpVerticalScrollView
{
    self.scrollView_vertical.pagingEnabled =YES;
//    self.scrollView_vertical.canCancelContentTouches = NO;
//    self.scrollView_vertical.delaysContentTouches = NO;
    
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
    collectionViewDataSource = [[EZRHomeCollectionViewDataSource alloc] initWithReusableCellIdentifier:@"feedItem"];
    self.collectionView_feedItems.dataSource = collectionViewDataSource;
    
    collectionViewDelegate = [[EZRHomeCollectionViewDelegate alloc] initWithController:self];
    self.collectionView_feedItems.delegate = collectionViewDelegate;
    
    collectionViewDataSource.feedItems = self.feedItems;
    _sortedFeedItems = collectionViewDataSource.sortedFeedItems;
    
    collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionViewLayout.minimumInteritemSpacing = 0;
    collectionViewLayout.minimumLineSpacing = 0;
    self.collectionView_feedItems.collectionViewLayout = collectionViewLayout;
    
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
 * Assigns observers for feeds
 */
- (void) setupFeedsObserver
{
    [self observeRelationship:@keypath(self.currentUser.feeds)
                  changeBlock:[self feedsDidChange]
               insertionBlock:nil
                 removalBlock:nil
             replacementBlock:nil
     ];
}

/**
 * Assigns observers for feedsItems when feeds array on current user changes
 */
- (void (^)(EZRHomeViewController *, NSSet *, NSSet *)) feedsDidChange
{
    return ^void(__weak EZRHomeViewController *_controller, NSSet *old, NSSet *new) {
        NSMutableArray *addedFeeds = [[new allObjects] mutableCopy];
        NSMutableArray *removedFeeds = [[old allObjects] mutableCopy];
        
        [addedFeeds removeObjectsInArray:[old allObjects]];
        [removedFeeds removeObjectsInArray:[new allObjects]];
        
        // Stop observing old feeds
        for ( Feed *feed in removedFeeds ){
            [feed removeAllObservations];
        }
        
        for (FeedItem *item in _feedItems) {
            if ([removedFeeds containsObject:item.feed]) {
                [_feedItems removeObject:item];
            }
        }
        
        // Observe added feeds
        for ( Feed *feed in addedFeeds ) {
            [feed observeRelationship:@"feedItems"
                          changeBlock:[self feedItemsDidChange]
                       insertionBlock:nil
                         removalBlock:nil
                     replacementBlock:nil];
            
            [_feedItems addObjectsFromArray:[feed.feedItems sortedArrayUsingDescriptors:nil]];
        }
        
        collectionViewDataSource.feedItems = _feedItems;
        _sortedFeedItems = collectionViewDataSource.sortedFeedItems;
        
        [self.collectionView_feedItems reloadData];

        if(self.currentFeedItem){
            [self scrollToCurrentFeedItem];
        }
    };
}

/**
 * Called when feedItems array on observed feeds change, shows new item button on page control
 */
- (void (^)(Feed *, NSSet *, NSSet *))feedItemsDidChange
{
    return ^void(Feed *feed, NSSet *old, NSSet *new) {
        EZRHomeCollectionViewDataSource *dataSource = self.collectionView_feedItems.dataSource;
        
        if(new) {
//            NSMutableArray *addedFeedItems = [[new allObjects] mutableCopy];
//            NSMutableArray *removedFeedItems = [[old allObjects] mutableCopy];
//            
//            [addedFeedItems removeObjectsInArray:[old allObjects]];
//            [removedFeedItems removeObjectsInArray:[new allObjects]];
//            
//            for( FeedItem *item in removedFeedItems ){
//                [_feedItems removeObject:item];
//            }
//            
//            for( FeedItem *item in addedFeedItems ){
//                [_feedItems addObject:item];
//            }
            
            _feedItems = [[[User current] feedItems] mutableCopy];
            dataSource.feedItems = _feedItems;
            _sortedFeedItems = dataSource.sortedFeedItems;
            
            [self.collectionView_feedItems reloadData];
            
            if (self.currentFeedItem)
            {
                [self scrollToCurrentFeedItem];
            }

            self.pageControl_itemIndicator.numberOfPages = [_feedItems count] < 6 ? [_feedItems count] : 5;
            [self.pageControl_itemIndicator setPageControllerPageAtIndex:self.currentPageIndex];
            
            if (_currentPageIndex == 0 && _currentFeedItem)
            {
                [self prefetchFirstImages];
            }
        }
    };
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
    NSUInteger index = [collectionViewDataSource.sortedFeedItems indexOfObject:_currentFeedItem];
    NSIndexPath *indexPath;
    
    // If the current index is greater than the feedItem array
    if (index > [collectionViewDataSource.sortedFeedItems count]-1){
        // Set the index to the last item in the array
        indexPath = [NSIndexPath indexPathForRow:[collectionViewDataSource.sortedFeedItems count]-1 inSection:0];
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
    if (_currentFeedItem.imageIphoneRetina)
    {
        [[EZRFeedImageService shared] fetchImageAtURLString: _currentFeedItem.imageIphoneRetina success:^(UIImage *image, UIImage *blurredImage) {
            [self prefetchImagesNearIndex:1 count:2];
        } failure:^{
            
        }];
    }

}
- (void)prefetchImagesNearIndex:(NSInteger)currentPageIndex count:(NSInteger)count
{
    NSInteger feedItemsCount = [collectionViewDataSource.sortedFeedItems count];
    
    NSInteger beginFetchIndex = currentPageIndex - count > 0 ? currentPageIndex - count : 0;
    NSInteger beforeFetchCount = currentPageIndex - count > 0 ?  count : currentPageIndex - beginFetchIndex;
    NSInteger afterFetchCount = currentPageIndex + count + 1 > feedItemsCount ? feedItemsCount - currentPageIndex : count;
    
    NSRange fetchRange = {beginFetchIndex, beforeFetchCount+afterFetchCount};
    
    NSArray *itemsToPrefetch = [collectionViewDataSource.sortedFeedItems subarrayWithRange:fetchRange];
    
    [[EZRFeedImageService shared] prefetchImagesForFeedItems:itemsToPrefetch];
    
}

@end


