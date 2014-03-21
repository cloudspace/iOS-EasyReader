//
//  CSCollectionPageControl.h
//  EasyReader
//
//  Created by Alfredo Uribe on 3/21/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCollectionPageControl : UIPageControl

@property UIButton *button_newItem;
@property UIView *view_maskLayer;
@property UIView *view_leftFade;
@property UIView *view_rightFade;

- (void)setPageControllerPageAtIndex:(int)index forCollection:(NSSet*)collection;
-(void)setUpFadesOnView:(UIView*)mask;

@end
