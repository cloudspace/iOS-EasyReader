//
//  CSCollectionPageControl.h
//  EasyReader
//
//  Created by Alfredo Uribe on 3/21/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSHomeViewController;

/**
 * Customized Page Control for collections of items
 */
@interface CSCollectionPageControl : UIPageControl

/**
 * The delegate for this class
 */
@property (nonatomic, retain) id delegate;

# pragma mark - Properties

/// Sorted Collection of items set from main view's datasource
@property NSArray *collection;

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
 * Sets hidden on new item button to true
 */
- (void)showNewItemButton;

@end
