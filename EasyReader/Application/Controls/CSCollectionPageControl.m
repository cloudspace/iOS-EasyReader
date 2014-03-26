//
//  CSCollectionPageControl.m
//  EasyReader
//
//  Created by Alfredo Uribe on 3/21/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSCollectionPageControl.h"
#import "CSFeedItemCollectionViewDataSource.h"
#import "CSHomeViewController.h"


/// Width of gradients
CGFloat const gradientWidth = 40.0;

/// How much the gradients move when animated
CGFloat const fadeMovement = 10.0;

/// The duration of most aniomations
CGFloat const kAnimationDuration = 0.75;


@implementation CSCollectionPageControl
{
    // Gets set once to calculated origin for fade views
    float leftFadeOrigin;
    float rightFadeOrigin;
    
    // x origin value for first indicator dot
    float xOrigin;
    // x origin value for last indicator dot
    float xLastOrigin;
    
    // y origin used to hide and show page control
    float yOrigin;
    
    /// Button that pops up when new items are added to collection
    UIButton *button_newItem;
    
    /// View to layer over buttons for gradients
    UIView *view_maskLayer;
    
    /// View for left fade gradient
    UIView *view_leftFade;
    
    /// View for right fade gradient
    UIView *view_rightFade;
}

/**
 * Sets up views to be loaded when storyboard starts up
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        yOrigin = self.frame.origin.y;
        
        view_maskLayer = [[UIView alloc] init];
        view_leftFade = [[UIView alloc] init];
        view_rightFade = [[UIView alloc] init];
        
        button_newItem = [UIButton buttonWithType:UIButtonTypeInfoLight];
        button_newItem.frame = CGRectMake(10,(self.frame.size.height/2)-5, 12, 12);
        
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
    
    NSMutableArray *subviews = [[self subviews] mutableCopy];
    
    [self insertSubview:view_maskLayer atIndex:[[self subviews] count]];
    [self insertSubview:button_newItem atIndex:[[self subviews] count]];
    
    int count = [subviews count] < 5 ? [subviews count] : 5;
    xOrigin = (self.frame.size.width/2)-( 3.5 + ((float)count/2)*12 );
    xLastOrigin = xOrigin + ([subviews count]*10.5);
    
    [self setUpFades];
    [self setPageControllerPageAtIndex:[self currentPage]];
    NSLog(@"something");
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
 * Sets up fade views for page controller
 */
-(void)setUpFades
{
    if ( !leftFadeOrigin ) leftFadeOrigin = xOrigin-15;
    view_leftFade.frame = CGRectMake(leftFadeOrigin, 10, gradientWidth, 20);
    view_leftFade.backgroundColor = [UIColor blackColor];
    
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = view_leftFade.bounds;
    leftLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    leftLayer.startPoint = CGPointMake(0.0f, 1.0f);
    leftLayer.endPoint = CGPointMake(1.0f, 1.0f);
    view_leftFade.layer.mask = leftLayer;
    
    if ( !rightFadeOrigin ) rightFadeOrigin = xLastOrigin-8.5;
    view_rightFade.frame = CGRectMake(rightFadeOrigin-8.5, 10, gradientWidth, 20);
    view_rightFade.backgroundColor = [UIColor blackColor];
    
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame = view_rightFade.bounds;
    rightLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    rightLayer.startPoint = CGPointMake(1.0f, 1.0f);
    rightLayer.endPoint = CGPointMake(0.0f, 1.0f);
    view_rightFade.layer.mask = rightLayer;
    
    [view_maskLayer addSubview:view_leftFade];
    [view_maskLayer addSubview:view_rightFade];
}

/**
 * Sets page to given index
 * Will display first, second, second to last, and last.. everything in the middle is on third page indicator
 * Also animates fades in and out when approaching ends
 */
- (void)setPageControllerPageAtIndex:(NSInteger)index
{
    NSInteger pageCount = self.numberOfPages;//[self.dataSource numberOfPagesForPageControl:self];
    
    if (pageCount < 5){
        self.currentPage = index;
        [UIView animateWithDuration:kAnimationDuration animations:^{
            view_leftFade.frame = CGRectMake(leftFadeOrigin-(fadeMovement*(2-index)), 10, gradientWidth, 20);
            view_rightFade.frame = CGRectMake(rightFadeOrigin+(fadeMovement*(3-(pageCount-index))), 10, gradientWidth, 20);
        }];
    } else {
        if( index < 3 ){
            self.currentPage = index;
            [UIView animateWithDuration:kAnimationDuration animations:^{
                if( self.frame.origin.y != yOrigin ){
                    [self showPageControl];
                }
                view_leftFade.frame = CGRectMake(leftFadeOrigin-(fadeMovement*(2-index)), 10, gradientWidth, 20);
            }];
        } else if(index > (pageCount-4) ){
            self.currentPage = 5-(pageCount-index);
            [UIView animateWithDuration:kAnimationDuration animations:^{
                if( self.frame.origin.y != yOrigin ){
                    [self showPageControl];
                }
                view_rightFade.frame = CGRectMake(rightFadeOrigin+(fadeMovement*(3-(pageCount-index))), 10, gradientWidth, 20);
            }];
        } else {
            self.currentPage = 2;
            
            if( self.frame.origin.y == yOrigin ){
                [UIView animateWithDuration:kAnimationDuration animations:^{
                    [self hidePageControl];
                }];
            }
            
            view_leftFade.frame = CGRectMake(leftFadeOrigin, 10, gradientWidth, 20);
            view_rightFade.frame = CGRectMake(rightFadeOrigin, 10, gradientWidth, 20);
        }
    }
}

/**
 * Alters Frame origin to slide page control down the screen until out of sight
 */
- (void) hidePageControl
{
    self.frame = CGRectMake(0, yOrigin+self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

/**
 * Alters Frame origin to slide page control up to its place at bottom of screen
 */
- (void) showPageControl
{
    self.frame = CGRectMake(0, yOrigin, self.frame.size.width, self.frame.size.height);
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

/**
 * Hides new item button
 */
- (void) hideNewItemButton
{
    [UIView animateWithDuration:.25 animations:^{
        [button_newItem setAlpha:0];
    }];
}

@end
