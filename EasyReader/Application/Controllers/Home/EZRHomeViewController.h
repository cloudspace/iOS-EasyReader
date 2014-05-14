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
#import "CSNestableScrollView.h"

// View Controllers
#import "CSBaseViewController.h"
#import "EZRNestableWebView.h"

@class User;

/**
 * The home view controller for the application
 */
@interface EZRHomeViewController : CSBaseViewController


# pragma mark - IBOutlet Properties

/// Vertical scroll view holding collection view and webviews
@property (weak, nonatomic) IBOutlet CSNestableScrollView *scrollView_vertical;

/// Button to go to left menu
@property (strong, nonatomic) IBOutlet UIButton *button_leftMenu;

/// Feed position indicator
@property (strong, nonatomic) IBOutlet CSCollectionPageControl *pageControl_itemIndicator;

/// The collection view which holds the individual feed items
@property (strong, nonatomic) IBOutlet EZRFeedItemCollectionView *collectionView_feedItems;


/// The up indicator displayed over the web view to assist in navigating to the top of the page
@property (nonatomic, strong) UIImageView *upIndicatorView;


# pragma mark - Properties

/// Feed Item currently visible
@property (nonatomic, readonly) FeedItem *currentFeedItem;

/// Feed Item currently visible
@property (nonatomic, readonly) NSInteger currentPageIndex;

/// Displays website that hosts article
@property (nonatomic, weak) IBOutlet EZRNestableWebView *webView_feedItem;

# pragma mark - Methods

/**
 * Loads the url for the new feed item in the web view
 *
 * @param feedItem The feed item to
 */
- (void) loadURLForFeedItem:(FeedItem *)feedItem;

/**
 * Resets the content of the web view
 */
- (void)resetWebView;

/**
 * Hides the scroll up indicator
 */
- (void)hideUpInidicator;
    
/**
 * Shows the scroll up indicator
 */
- (void)showUpInidicator;

@end
