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


# pragma mark - IBOutlet

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

/// Feed items on user
@property (nonatomic, strong) NSMutableSet *feedItems;

/// Current User
@property (nonatomic, retain) User* currentUser;

/// Data source for Collection view
@property EZRHomeCollectionViewDataSource *feedCollectionViewDataSource;

/// Feed Item currently visible
@property FeedItem *currentFeedItem;

/// Integer id for the Collection cell that user is scrolling to
@property NSInteger collectionCellGoingTo;


# pragma mark - Methods

/** 
 * Scrolls through collection view to display whatever item is set to currentItem
 */
- (void)scrollToCurrentFeedItem;

@end
