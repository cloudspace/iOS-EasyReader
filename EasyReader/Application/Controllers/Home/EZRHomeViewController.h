//
//  CSFeedCollectionViewController.h
//  EasyReader
//
//  Created by Joseph Lorich on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>

// Controls
#import "CSCollectionPageControl.h"
#import "EZRFeedItemCollectionView.h"

// View Controllers
#import "CSBaseViewController.h"
#import "EZRHomeCollectionViewDataSource.h"

@class User;

/**
 * The home view controller for the application
 */
@interface EZRHomeViewController : CSBaseViewController


# pragma mark - IBOutlet Properties

/// Vertical scroll view holding collection view and webviews
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_vertical;

/// Button to go to left menu
@property (strong, nonatomic) IBOutlet UIButton *button_leftMenu;

/// Feed position indicator
@property (strong, nonatomic) IBOutlet CSCollectionPageControl *pageControl_itemIndicator;

/// The collection view which holds the individual feed items
@property (strong, nonatomic) IBOutlet EZRFeedItemCollectionView *collectionView_feedItems;

/// Displays website that hosts article
@property (nonatomic, strong) UIWebView *webView_feedItem;


# pragma mark - Properties

/// Feed Item currently visible
@property (nonatomic, readonly) FeedItem *currentFeedItem;

/// Feed Item currently visible
@property (nonatomic, readonly) NSInteger currentPageIndex;

/// The feed items visible on this view controller
@property (nonatomic, readonly) NSMutableSet *feedItems;

/// A sorted array of feed items
@property (nonatomic, readonly) NSArray *sortedFeedItems;


# pragma mark - Methods

/** 
 * Scrolls through collection view to display whatever item is set to currentItem
 */
- (void)scrollToCurrentFeedItem;

@end
