//
//  UIView+PlaceholderAdditions.m
//  uwithus
//
//  Created by Joseph Lorich on 3/10/14.
//  Copyright (c) 2014 CSORGNAME. All rights reserved.
//

#import "UIView+PlaceholderAdditions.h"
#import <objc/runtime.h>
#import <Block-KVO/MTKObserving.h>


static void *PlaceholderPropertyKey = &PlaceholderPropertyKey;

@implementation UIView (PlaceholderAdditions)

- (UIView *)placeholderView {
  return objc_getAssociatedObject(self, PlaceholderPropertyKey);
}

- (void)setPlaceholderView:(NSArray *)placeholderView {
  objc_setAssociatedObject(self, PlaceholderPropertyKey, placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/**
 * Generates a frame centered over another frame
 */
- (CGRect)centeredFrame:(CGRect)frame overFrame:(CGRect)overFrame
{
  return CGRectMake(
                    overFrame.origin.x + overFrame.size.width/2.0 - frame.size.width/2.0,
                    overFrame.origin.y + overFrame.size.height/2.0 - frame.size.height/2.0,
                    frame.size.width,
                    frame.size.height
                    );
}

/**
 * Updates the placeholderView frame on parent frame change
 */
- (void)frameDidChange:(id)sender
{
  if (self.placeholderView)
  {
    CGRect frame = [self centeredFrame:self.placeholderView.frame overFrame:self.frame];
    [self.placeholderView setFrame:frame];
  }
}

- (void)insertCenteredPlaceholderView:(UIView *)placeholderView
{
  [self removeAllObservations];
  [self observeProperty:@"bounds" withSelector:@selector(frameDidChange:)];
  
  CGRect frame = [self centeredFrame:placeholderView.frame overFrame:self.frame];
  [placeholderView setFrame:frame];
  
  [self addSubview:placeholderView];
  
  if (self.placeholderView)
  {
    [self.placeholderView removeFromSuperview];
  }
  
  self.placeholderView = placeholderView;

}

- (void)hideAndInstantiatePlaceHolderWithView:(UIView *)placeholderView
{
  [self removeAllObservations];
  [self observeProperty:@"bounds" withSelector:@selector(frameDidChange:)];
  
  
  CGRect frame = [self centeredFrame:placeholderView.frame overFrame:self.frame];
  [placeholderView setFrame:frame];
  
  [self setHidden:YES];
  [[self superview] addSubview:placeholderView];
  
  if (self.placeholderView)
  {
    [self.placeholderView removeFromSuperview];
  }
  
  self.placeholderView = placeholderView;
}

- (void)removePlaceholderViewAndShow
{
  [self removeAllObservations];
  [self.placeholderView removeFromSuperview];
  
  self.placeholderView = nil;
  
  [self setHidden:NO];
}


- (void)hideAndInstantiatePlaceHolderWithTitle:(NSString *)title
{
  UIView *placeholder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
  [label setTextColor:[UIColor lightGrayColor]];
  [label setTextAlignment:NSTextAlignmentCenter];
  [label setLineBreakMode:NSLineBreakByWordWrapping];
  [label setNumberOfLines:3];
  [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0f]];

  [label setText:title];
  
  [placeholder addSubview:label];
  
  
  [self hideAndInstantiatePlaceHolderWithView:placeholder];
}



@end
