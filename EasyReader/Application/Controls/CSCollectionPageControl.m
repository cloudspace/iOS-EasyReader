//
//  CSCollectionPageControl.m
//  EasyReader
//
//  Created by Alfredo Uribe on 3/21/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSCollectionPageControl.h"

@implementation CSCollectionPageControl

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self) {
    UIButton *dot = [UIButton buttonWithType:UIButtonTypeInfoLight];
    dot.frame = CGRectMake(10,(self.frame.size.height/2)-5, 12, 12);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newItemButton:)];
    [dot addGestureRecognizer:singleTap];
    
    [self addSubview:dot];
  }
  return self;
}

-(void)setUpFadesOnView:(UIView*)mask
{
  _view_maskLayer = [[UIView alloc] init];
  _view_leftFade = [[UIView alloc] init];
  _view_leftFade.frame = CGRectMake(110, 10, 30, 20);
  _view_leftFade.backgroundColor = [UIColor blackColor];
  
  CAGradientLayer *leftLayer = [CAGradientLayer layer];
  leftLayer.frame = _view_leftFade.bounds;
  leftLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
  leftLayer.startPoint = CGPointMake(0.0f, 1.0f);
  leftLayer.endPoint = CGPointMake(1.0f, 1.0f);
  _view_leftFade.layer.mask = leftLayer;
  
  _view_rightFade = [[UIView alloc] init];
  _view_rightFade.frame = CGRectMake(160, 10, 50, 20);
  _view_rightFade.backgroundColor = [UIColor blackColor];
  
  CAGradientLayer *rightLayer = [CAGradientLayer layer];
  rightLayer.frame = _view_rightFade.bounds;
  rightLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
  rightLayer.startPoint = CGPointMake(1.0f, 1.0f);
  rightLayer.endPoint = CGPointMake(0.0f, 1.0f);
  _view_rightFade.layer.mask = rightLayer;
  
  [_view_maskLayer addSubview:_view_leftFade];
  [_view_maskLayer addSubview:_view_rightFade];
  [mask addSubview:_view_maskLayer];
  NSLog(@"added?");
}

- (void)setPageControllerPageAtIndex:(int)index forCollection:(NSSet*)collection
{
  if ([collection count] < 6){
    self.currentPage = index;
  } else {
    if( index <= 2 ){
      self.currentPage = index;
      [_view_leftFade setHidden:YES];
    } else if(index > ([collection count]-3) ){
      self.currentPage = 5-([collection count]-index);
      [_view_rightFade setHidden:YES];
    } else {
      self.currentPage = 2;
      [_view_leftFade setHidden:NO];
      [_view_rightFade setHidden:NO];
    }
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
