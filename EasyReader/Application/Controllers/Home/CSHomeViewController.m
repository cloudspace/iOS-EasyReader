//
//  CSFeedCollectionViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSHomeViewController.h"

// Pods
#import <Block-KVO/MTKObserving.h>
#import "MFSideMenu.h"

// Models
#import "FeedItem.h"
#import "Feed.h"
#import "User.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIColor+EZRSharedColorAdditions.h"

#import "EZRFeedItemCell.h"

#import "EZRFeedImageService.h"


typedef void (^ObserverBlock)(__weak CSHomeViewController *self, NSSet *old, NSSet *new);

@implementation CSHomeViewController
{
    NSString *currentURL;
    NSInteger _currentPageIndex;
    BOOL hasPrefetchedFirstFeeds;
}

/**
 * Set up data sctructures, controller views, add observers
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    _feedItems = [[NSMutableSet alloc] init];
    
    [_pageControl_itemIndicator setUpFadesOnView:[_pageControl_itemIndicator superview]];
    _pageControl_itemIndicator.controller_owner = self;
    
    
    _currentPageIndex = 0;
    
    self.currentUser = [User current];
    
    [self setUpVerticalScrollView];
    [self setUpCollectionView];
    [self setUpWebView];
    [self setupFeedsObserver];
    
    [self.pageControl_itemIndicator setBackgroundColor:[UIColor EZR_charcoal]];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setUpVerticalScrollView];
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait;
}

-(BOOL)shouldAutorotate {
    return NO;
}



#pragma mark Observations

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
-(ObserverBlock) feedsDidChange
{
    return ^void(__weak CSHomeViewController *self, NSSet *old, NSSet *new) {
        NSMutableArray *addedFeeds = [[new allObjects] mutableCopy];
        NSMutableArray *removedFeeds = [[old allObjects] mutableCopy];
        
        [addedFeeds removeObjectsInArray:[old allObjects]];
        [removedFeeds removeObjectsInArray:[new allObjects]];
        
        // Stop observing old feeds
        for ( Feed *feed in removedFeeds ){
            [feed removeAllObservations];
        }

        // Observe added feeds
        for ( Feed *feed in addedFeeds ){
            [feed observeRelationship:@"feedItems"
                          changeBlock:[self feedItemsDidChange]
                       insertionBlock:nil
                         removalBlock:nil
                     replacementBlock:nil];
        }
        
        //redraw the collection with the changes to the new feed items
        
        _feedItems = [_currentUser.feedItems mutableCopy];
        _feedCollectionViewDataSource.feedItems = _feedItems;

        
        [_collectionView_feedItems reloadData];
        
        
        _pageControl_itemIndicator.numberOfPages = [_feedItems count] < 6 ? [_feedItems count] : 5;
        
        if(_currentFeedItem){
            [self scrollToCurrentFeedItem];
            [_pageControl_itemIndicator setPageControllerPageAtIndex:[_feedCollectionViewDataSource.sortedFeedItems indexOfObject:_currentFeedItem]
                                                       forCollection:_feedItems];
        } else {
            [_pageControl_itemIndicator setPageControllerPageAtIndex:0 forCollection:_feedItems];
        }
    };
}

/**
 * Called when feedItems array on observed feeds change, shows new item button on page control
 */
-(void (^)(Feed *, NSSet *, NSSet *)) feedItemsDidChange
{
    __weak CSHomeViewController *controller = self;
    
    return ^void(Feed *self, NSSet *old, NSSet *new) {
        CSFeedItemCollectionViewDataSource *dataSource = (CSFeedItemCollectionViewDataSource *)controller.collectionView_feedItems.dataSource;
        
        controller.feedItems = [dataSource.feedItems mutableCopy];
        
        if(!new) {
            NSLog(@"There are no feed items here");
        } else {
            NSMutableArray *addedFeedItems = [[new allObjects] mutableCopy];
            NSMutableArray *removedFeedItems = [[old allObjects] mutableCopy];
            
            [addedFeedItems removeObjectsInArray:[old allObjects]];
            [removedFeedItems removeObjectsInArray:[new allObjects]];
            
            for( FeedItem *item in removedFeedItems ){
                [controller.feedItems removeObject:item];
            }
            
            for( FeedItem *item in addedFeedItems ){
                [controller.feedItems addObject:item];
            }
            
            if (_currentPageIndex == 0)
            {
                [controller prefetchImagesNearIndex:0 count:5];
            }
            
            dataSource.feedItems = controller.feedItems;
            [controller.collectionView_feedItems reloadData];
            if (controller.currentFeedItem) [controller scrollToCurrentFeedItem];
            
            [_pageControl_itemIndicator.button_newItem setHidden:NO];
        }
    };
}

#pragma mark - IBActions

// Receives left menu link click
- (IBAction)buttonLeftMenu_touchUpInside_goToMenu:(id)sender {
    [[self rootViewController] toggleLeftSideMenuCompletion:^{}];
}


/**
 * Sets up vertical scroll view on controller start up
 */
-(void)setUpVerticalScrollView{
    // Set contentSize to be twice the height of the scrollview
    NSInteger width = self.verticalScrollView.frame.size.width;
    NSInteger height = self.verticalScrollView.frame.size.height;
    self.verticalScrollView.contentSize = CGSizeMake(width, height*2);
    
    self.verticalScrollView.pagingEnabled =YES;
    self.verticalScrollView.delegate = self;
}

/**
 * Sets up collection view on controller start up
 */
- (void)setUpCollectionView
{
    //    NSArray *feedItems = [FeedItem MR_findAll];
    NSSet *feedItems = _currentUser.feedItems;
    
    _feedCollectionViewDataSource = [[CSFeedItemCollectionViewDataSource alloc] initWithFeedItems:feedItems
                                                                           reusableCellIdentifier:@"feedItem"];
    
    self.collectionView_feedItems.dataSource = _feedCollectionViewDataSource;
    self.collectionView_feedItems.delegate = self;
}

/**
 * Sets up collection view on controller start up
 */
-(void)setUpWebView
{
    // Create a new webview and place it below the collectionView
    self.feedItemWebView = [[UIWebView alloc] init];
    NSInteger width = self.verticalScrollView.frame.size.width;
    NSInteger height = self.verticalScrollView.frame.size.height;
    self.feedItemWebView.frame= CGRectMake(0, height, width, height*2);
    [self.feedItemWebView setBackgroundColor:[UIColor blackColor]];
    
    // Add it to the bottom of the scrollView
    [self.verticalScrollView addSubview:self.feedItemWebView];
}

- (void)loadFeedItemWebView
{
    // Check if this is a new url
    if(currentURL != self.collectionView_feedItems.currentFeedItem.url){
        // update the current url
        currentURL = self.collectionView_feedItems.currentFeedItem.url;
        
        // load the url in the webView
        NSURL *url = [NSURL URLWithString:currentURL];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.feedItemWebView loadRequest:requestObj];
    }
}

# pragma mark - ScrollView methods

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

# pragma mark - ScrollView Delegate methods

/**
 * Scroll view delegate method for dragging view up into webview
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)sender {
    // If we are scrolling in the scrollView only not a subclass
    if([sender isMemberOfClass:[UIScrollView class]]) {
        [self loadFeedItemWebView];
    }
}

# pragma mark - CollectionView Delegate methods


- (void)prefetchImagesNearIndex:(NSInteger)currentPageIndex count:(NSInteger)count
{
    NSInteger feedItemsCount = [_feedCollectionViewDataSource.sortedFeedItems count];
    
    NSInteger beginFetchIndex = currentPageIndex - count > 0 ? currentPageIndex - count : 0;
    NSInteger beforeFetchCount = currentPageIndex - count > 0 ?  count : currentPageIndex - beginFetchIndex;
    NSInteger afterFetchCount = currentPageIndex + count + 1 > feedItemsCount ? feedItemsCount - currentPageIndex : count;
    
    NSRange fetchRange = {beginFetchIndex, beforeFetchCount+afterFetchCount};
    
    /// TODO: crashes at end
    
    NSArray *itemsToPrefetch = [_feedCollectionViewDataSource.sortedFeedItems subarrayWithRange:fetchRange];
    
    [[EZRFeedImageService shared] prefetchImagesForFeedItems:itemsToPrefetch];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([scrollView isMemberOfClass:[CSFeedItemCollectionView class]]) {
        CGFloat pageWidth = _collectionView_feedItems.frame.size.width;
        
        // We add half the page width to the offset to consider the most-centered page to be the current one, not
        // the page currently under the leftmost position of the view
        NSInteger pageIndex = ((scrollView.contentOffset.x + pageWidth/2.0) / pageWidth);
        
        if (_currentPageIndex != pageIndex)
        {
            _currentPageIndex = pageIndex;
            [self prefetchImagesNearIndex:pageIndex count:5];
        }
        
        //[self.pageControl_itemIndicator setPageControllerPageAtIndex:(int)pageIndex];
    }
}

/**
 * Collection view delegate method for updating current feed item webview url
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    // If we are scrolling in the collectionView only
    if([sender isMemberOfClass:[CSFeedItemCollectionView class]]) {
        // unload the webView if we have moved to a new feedItem
        if(_currentFeedItem != self.collectionView_feedItems.currentFeedItem){
            _currentFeedItem = self.collectionView_feedItems.currentFeedItem;
            [self.feedItemWebView loadHTMLString:@"<html><head></head><body style=\"background-color: #000000;\"></body></html>" baseURL:nil];
        }
    }
}

/**
 * Collection view delegate method for when a cell ends display
 * Sets page control indicator
 */
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger newIndex = indexPath.row+((indexPath.row-self.collectionCellGoingTo)*-1);
    
    [_pageControl_itemIndicator setPageControllerPageAtIndex:newIndex
                                               forCollection:_feedItems];
}

@end
