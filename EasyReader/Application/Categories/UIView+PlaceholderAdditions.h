
//
//  UIView+PlaceholderAdditions.h
//  uwithus
//
//  Created by Joseph Lorich on 3/10/14.
//  Copyright (c) 2014 CSORGNAME. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Helpful additions for adding placeholders instead of an empty UIView
 */
@interface UIView (PlaceholderAdditions)


#pragma mark - Methods

/**
 * Hides the current UIView and adds the given placeholder centered over where this view was
 * Replaces any pre-existing placeholder views on this view
 */
- (void)hideAndInstantiatePlaceHolderWithView:(UIView *)placeholderView;

/**
 * Inserts the given placeholder centered inside this view.
 * Replaces any pre-existing placeholder views on this view
 */
- (void)insertCenteredPlaceholderView:(UIView *)placeholderView;

/**
 * Removes all placeholder views and shows the original view
 */
- (void)removePlaceholderViewAndShow;

/**
 * Generates a plain placeholder with a title and replaces the current view with it
 */
- (void)hideAndInstantiatePlaceHolderWithTitle:(NSString *)title;


#pragma mark - Properties

/// An array of currently existing placholder views
@property (nonatomic, retain) UIView *placeholderView;


@end
