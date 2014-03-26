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
#import "CSFeedItemCollectionView.h"

// View Controllers
#import "CSBaseViewController.h"
#import "CSFeedItemCollectionViewDataSource.h"
#import "CSCollectionPageControlDelegate.h"

@class User;

/**
 * The home view controller for the application
 */
@interface CSHomeViewController : CSBaseViewController <
  UICollectionViewDelegate,
  UIScrollViewDelegate,
  CSCollectionPageControlDelegate
>


# pragma mark - IBOutlet

/// Vertical scroll view holding collection view and webviews
@property (weak, nonatomic) IBOutlet UIScrollView *verticalScrollView;

/// Button to go to left menu
@property (strong, nonatomic) IBOutlet UIButton *button_leftMenu;

/// Feed position indicator
@property (strong, nonatomic) IBOutlet CSCollectionPageControl *pageControl_itemIndicator;

/// The collection view which holds the individual feed items
@property (strong, nonatomic) IBOutlet CSFeedItemCollectionView *collectionView_feedItems;


# pragma mark - Properties

/// Displays website that hosts article
@property (nonatomic, strong) UIWebView *feedItemWebView;

/// Feed items on user
@property (nonatomic, strong) NSMutableSet *feedItems;

/// Current User
@property (nonatomic, retain) User* currentUser;

/// Data source for Collection view
@property CSFeedItemCollectionViewDataSource *feedCollectionViewDataSource;

/// Feed Item currently visible
@property FeedItem *currentFeedItem;


# pragma mark - Methods

/** 
 * Scrolls through collection view to display whatever item is set to currentItem
 */
- (void)scrollToCurrentFeedItem;

@end
