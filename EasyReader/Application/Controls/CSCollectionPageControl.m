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

@implementation CSCollectionPageControl
{
  float leftFadeOrigin;
  float rightFadeOrigin;
  float gradientWidth;
  float fadeMovement;
  float xOrigin;
  float xLastOrigin;
  float yOrigin;
}

/**
 * Sets up views to be loaded when storyboard starts up
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    yOrigin = self.frame.origin.y;
    
    _view_maskLayer = [[UIView alloc] init];
    _view_leftFade = [[UIView alloc] init];
    _view_rightFade = [[UIView alloc] init];
    
    _button_newItem = [UIButton buttonWithType:UIButtonTypeInfoLight];
    _button_newItem.frame = CGRectMake(10,(self.frame.size.height/2)-5, 12, 12);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newItemButton:)];
    [_button_newItem addGestureRecognizer:singleTap];
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

  [self insertSubview:_view_maskLayer atIndex:[[self subviews] count]];
  [self insertSubview:_button_newItem atIndex:[[self subviews] count]];
  
  int count = [subviews count] < 5 ? [subviews count] : 5;
  xOrigin = (self.frame.size.width/2)-( 3.5 + ((float)count/2)*12 );
  xLastOrigin = xOrigin + ([subviews count]*10.5);
  
  [self setUpFades];
  [self setPageControllerPageAtIndex:[self currentPage]
                   forCollectionSize:[_controller_owner.feedItems count]];
  NSLog(@"something");
}


/**
 * Sets up button that takes user to newest item added to collection
 */
-(void)newItemButton:(id)sender
{
  CSFeedItemCollectionViewDataSource *dataSource = [_controller_owner feedCollectionViewDataSource];
  [_controller_owner setCurrentFeedItem:[[dataSource sortedFeedItems] firstObject]];
  [_controller_owner scrollToCurrentFeedItem];
  _controller_owner.collectionCellGoingTo = 0;
  [self setPageControllerPageAtIndex:[[dataSource sortedFeedItems]indexOfObject:_controller_owner.currentFeedItem]
                   forCollectionSize:[_controller_owner.feedItems count]];
}

/**
 * Sets up fade views for page controller
 */
-(void)setUpFades
{
  gradientWidth = 40;
  fadeMovement = 10;
  
  _view_leftFade.frame = CGRectMake(xOrigin-15, 10, gradientWidth, 20);
  leftFadeOrigin = 115;
  _view_leftFade.backgroundColor = [UIColor blackColor];
  
  CAGradientLayer *leftLayer = [CAGradientLayer layer];
  leftLayer.frame = _view_leftFade.bounds;
  leftLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
  leftLayer.startPoint = CGPointMake(0.0f, 1.0f);
  leftLayer.endPoint = CGPointMake(1.0f, 1.0f);
  _view_leftFade.layer.mask = leftLayer;

  _view_rightFade.frame = CGRectMake(xLastOrigin-8.5, 10, gradientWidth, 20);
  rightFadeOrigin = 165;
  _view_rightFade.backgroundColor = [UIColor blackColor];
  
  CAGradientLayer *rightLayer = [CAGradientLayer layer];
  rightLayer.frame = _view_rightFade.bounds;
  rightLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
  rightLayer.startPoint = CGPointMake(1.0f, 1.0f);
  rightLayer.endPoint = CGPointMake(0.0f, 1.0f);
  _view_rightFade.layer.mask = rightLayer;
  
  [_view_maskLayer addSubview:_view_leftFade];
  [_view_maskLayer addSubview:_view_rightFade];
}

/**
 * Sets page to given index
 * Will display first, second, second to last, and last.. everything in the middle is on third page indicator
 * Also animates fades in and out when approaching ends
 */
- (void)setPageControllerPageAtIndex:(NSInteger)index forCollectionSize:(NSInteger)size
{
  if (size < 5){
    self.currentPage = index;
    [UIView animateWithDuration:.75 animations:^{
      _view_leftFade.frame = CGRectMake(leftFadeOrigin-(fadeMovement*(2-index)), 10, gradientWidth, 20);
      _view_rightFade.frame = CGRectMake(rightFadeOrigin+(fadeMovement*(3-(size-index))), 10, gradientWidth, 20);
    }];
  } else {
    if( index < 3 ){
      self.currentPage = index;
      [UIView animateWithDuration:.75 animations:^{
        if( self.frame.origin.y != yOrigin ){
          self.frame = CGRectMake(0, yOrigin, self.frame.size.width, self.frame.size.height);
        }
        _view_leftFade.frame = CGRectMake(leftFadeOrigin-(fadeMovement*(2-index)), 10, gradientWidth, 20);
      }];
    } else if(index > (size-4) ){
      self.currentPage = 5-(size-index);
      [UIView animateWithDuration:.75 animations:^{
        if( self.frame.origin.y != yOrigin ){
          self.frame = CGRectMake(0, yOrigin, self.frame.size.width, self.frame.size.height);
        }
        _view_rightFade.frame = CGRectMake(rightFadeOrigin+(fadeMovement*(3-(size-index))), 10, gradientWidth, 20);
      }];
    } else {
      self.currentPage = 2;
      
      if( self.frame.origin.y == yOrigin ){
        [UIView animateWithDuration:.75 animations:^{
          self.frame = CGRectMake(0, yOrigin+self.frame.size.height, self.frame.size.width, self.frame.size.height);
        }];
      }
      
      _view_leftFade.frame = CGRectMake(leftFadeOrigin, 10, gradientWidth, 20);
      _view_rightFade.frame = CGRectMake(rightFadeOrigin, 10, gradientWidth, 20);
    }
  }
}

@end
