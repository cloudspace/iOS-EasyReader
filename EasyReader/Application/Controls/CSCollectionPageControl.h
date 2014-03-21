//
//  CSCollectionPageControl.h
//  EasyReader
//
//  Created by Alfredo Uribe on 3/21/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSHomeViewController;

@interface CSCollectionPageControl : UIPageControl

@property CSHomeViewController *controller_owner;
@property UIButton *button_newItem;
@property UIView *view_maskLayer;
@property UIView *view_leftFade;
@property UIView *view_rightFade;

- (void)setPageControllerPageAtIndex:(NSInteger)index forCollection:(NSSet*)collection;
- (void)setUpFadesOnView:(UIView*)mask;

@end
