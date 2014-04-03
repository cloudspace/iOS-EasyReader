//
//  CSCollectionPageControl.m
//  EasyReader
//
//  Created by Alfredo Uribe on 3/21/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSCollectionPageControl.h"
#import "EZRHomeCollectionViewDataSource.h"
#import "EZRHomeViewController.h"


/// Width of gradients
CGFloat const gradientWidth = 40.0;

/// How much the gradients move when animated
CGFloat const fadeMovement = 10.0;

/// The duration of most aniomations
CGFloat const kAnimationDuration = 0.25;


@implementation CSCollectionPageControl
{
    /// Button that pops up when new items are added to collection
    UIButton *button_newItem;
    
    BOOL fadingOut;
    BOOL fadingIn;
}

/**
 * Sets up views to be loaded when storyboard starts up
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        button_newItem = [UIButton buttonWithType:UIButtonTypeInfoLight];
        button_newItem.alpha = 0.0f;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newItemButton:)];
        [button_newItem addGestureRecognizer:singleTap];
    }
    return self;
}

/**
 * Properly layers gradients over page control dots
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect buttonFrame = CGRectMake(10,(CGRectGetHeight(self.frame)/2)-5, 12, 12);
    [button_newItem setFrame:buttonFrame];
    
    
    [self fadeRightSubviews];
}

/**
 * Sets up button that takes user to newest item added to collection
 */
-(void)newItemButton:(id)sender
{
    [self hideNewItemButton];
    
    if ([self.delegate respondsToSelector:@selector(pageControl:didSelectPageAtIndex:)])
    {
        [self.delegate pageControl:self didSelectPageAtIndex:0];
    }
    
    [self setPageControllerPageAtIndex:0];
}

/**
 * Sets page to given index
 * Will display first, second, second to last, and last.. everything in the middle is on third page indicator
 * Also animates fades in and out when approaching ends
 */
- (void)setPageControllerPageAtIndex:(NSInteger)index {
    NSInteger pageCount = [self.datasource numberOfPagesForPageControl];
    NSInteger beginFadeIndex = floor(self.numberOfPages/2.0);
    NSInteger endFadeIndex = pageCount - floor(self.numberOfPages/2.0);
    
    if (pageCount <= self.numberOfPages){
        self.currentPage = index;
        [self fadeInSubviews];
        return;
    }
    
    if (index < beginFadeIndex) {
        self.currentPage = index;
        [self fadeInSubviews];
        [self fadeRightSubviews];
    } else if (index >= endFadeIndex) {
        self.currentPage = self.numberOfPages - (pageCount - index);
        [self fadeInSubviews];
        [self fadeLeftSubviews];
    } else {
        // Dont set a current page here as we're hiding the control anyway
        [self fadeOutSubviews];
    }
    
    
}

/**
 * Returns an array of the page controls subviews sorted by the minimum X frame value
 */
- (NSArray *)sortedSubviews
{
    NSArray *sortedSubviews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
        CGFloat min1 = CGRectGetMinX(obj1.frame);
        CGFloat min2 = CGRectGetMinX(obj2.frame);
        
        if (min1 < min2) {
            return NSOrderedAscending;
        } else if (min2 < min1) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
        
    }];
    
    return sortedSubviews;
}

- (void)fadeRightSubviews
{
    NSArray *sortedSubviews = [self sortedSubviews];

    NSInteger numberOfPagesToFade = ceil(self.numberOfPages/2.0);
    NSInteger count = 1;
    for (NSInteger i = self.numberOfPages - 1; i > self.numberOfPages - 1 - numberOfPagesToFade; i--)
    {
        CGFloat alpha = 100.0/(numberOfPagesToFade+1)/100.0*count;
        
        [sortedSubviews[i] setAlpha:alpha];
        
        count++;
    }
}

- (void)fadeLeftSubviews
{
    NSArray *sortedSubviews = [self sortedSubviews];
    
    NSInteger numberOfPagesToFade = ceil(self.numberOfPages/2.0);
    for (NSInteger i = 0; i < numberOfPagesToFade; i++)
    {
        CGFloat alpha = 100.0/(numberOfPagesToFade+1)/100.0*(i+1);
        
        [sortedSubviews[i] setAlpha:alpha];
    }
}

/**
 * Fades out all subviews except the new button
 */
- (void)fadeOutSubviews
{
    if (!fadingOut)
    {
        fadingOut = YES;
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            for (UIView *view in self.subviews) {
                view.alpha = 0.0f;
            }
        } completion:^(BOOL finished) {
            fadingOut = NO;
        }];
    }
}

/**
 * Fades in all subviews
 */
- (void)fadeInSubviews
{
    if (!fadingIn)
    {
        fadingIn = YES;
        
        [UIView animateWithDuration:kAnimationDuration animations:^{
            for (UIView *view in self.subviews) {
                view.alpha = 1.0f;
            }
        } completion:^(BOOL finished) {
            fadingIn = NO;
        }];
    }
}


/**
 * Hides new item button
 */
- (void) hideNewItemButton
{
    [UIView animateWithDuration:.25 animations:^{
        [button_newItem setAlpha:0];
    }];
}

/**
 * Shows new item button
 */
- (void) showNewItemButton
{
    [UIView animateWithDuration:.25 animations:^{
        [button_newItem setAlpha:1];
    }];
}

@end