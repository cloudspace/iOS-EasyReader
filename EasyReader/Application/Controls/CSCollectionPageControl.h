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

# pragma mark - Property

/// Reference to controller that owns page control
@property CSHomeViewController *controller_owner;

/// Button that pops up when new items are added to collection
@property UIButton *button_newItem;

/// View to layer over buttons for gradients
@property UIView *view_maskLayer;

/// View for left fade gradient
@property UIView *view_leftFade;

/// View for right fade gradient
@property UIView *view_rightFade;


# pragma mark - Methods

/**
 * Sets page to given index
 * Will display first, second, second to last, and last.. everything in the middle is on third page indicator
 * Also animates fades in and out when approaching ends
 */
- (void)setPageControllerPageAtIndex:(NSInteger)index forCollectionSize:(NSInteger)size;

/**
 * Sets up fade views for page controller
 */
- (void)setUpFades;

@end
