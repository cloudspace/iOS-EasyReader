//
//  CSCollectionPageControl.h
//  EasyReader
//
//  Created by Alfredo Uribe on 3/21/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSHomeViewController;
@class CSCollectionPageControl;


#pragma mark - CSCollectionPageControlDelegate

/**
 * This protocol represents the behaviour of the the page control.
 */
@protocol CSCollectionPageControlDelegate <NSObject>

/**
 * Tells the delegate that the specified page index was selected
 *
 * @param pageControl A Page Control informing the delegate about a new page selection
 * @param index An index locating the selected page
 */
- (void)pageControl:(CSCollectionPageControl*)pageControl didSelectPageAtIndex:(NSInteger)index;

@end


#pragma mark - CSCollectionPageControlDataSource

/**
 * This protocol represents the data source for this page control
 */
@protocol CSCollectionPageControlDataSource <NSObject>

@required

/**
 * Datasource sets pages count for page control
 *
 * @param pageControl A Page Control informing the delegate about a new page selection
 * @param pages for count of items for page control
 */
- (NSInteger)numberOfPagesForPageControl;

@end


#pragma mark - CSCollectionPageControl

/**
 * Customized Page Control for collections of items
 */
@interface CSCollectionPageControl : UIPageControl


# pragma mark - Properties

/// The object that acts as the delegate of the receiving page control
@property (nonatomic, assign) id<CSCollectionPageControlDelegate> delegate;

/// The object that acts as the delegate of the receiving page control
@property (nonatomic, assign) id<CSCollectionPageControlDataSource> datasource;


# pragma mark - Methods

/**
 * Sets page to given index
 * Will display first, second, second to last, and last.. everything in the middle is on third page indicator
 * Also animates fades in and out when approaching ends
 */
- (void)setPageControllerPageAtIndex:(NSInteger)index;

/**
 * Alters Frame origin to slide page control up to its place at bottom of screen
 */
- (void)showPageControl;

/**
 * Shows new item button
 */
- (void) showNewItemButton;

@end
