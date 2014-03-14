//
//  CSVerticalScrollViewDelegate.h
//  EasyReader
//
//  Created by Michael Beattie on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSFeedItemContainerViewController.h"

@interface CSVerticalScrollViewDelegate : NSObject <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollViewController;

- (id)initWithScrollView:(UIScrollView *)scrollView;

@end
