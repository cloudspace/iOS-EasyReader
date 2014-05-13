//
//  CSCollectionPageControl.h
//  EasyReader
//
//  Created by Alfredo Uribe on 3/21/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EZRHomeViewController;
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
 * Returns the page count to be used in the page control
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
@property (nonatomic, assign) IBOutlet id<CSCollectionPageControlDelegate> delegate;

/// The object that acts as the delegate of the receiving page control
@property (nonatomic, assign) IBOutlet id<CSCollectionPageControlDataSource> datasource;


# pragma mark - Methods

/**
 * Sets page to given index
 * Will display first, second, second to last, and last.. everything in the middle is on third page indicator
 * Also animates fades in and out when approaching ends
 *
 * @param index The index to set the page control page to
 */
- (void)setPageControllerPageAtIndex:(NSInteger)index;

@end