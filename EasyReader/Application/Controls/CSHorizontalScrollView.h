//
//  CSHorizontalScrollView.h
//  EasyReader
//
//  Created by Michael Beattie on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSFeedItemContainerViewController.h"

@interface CSHorizontalScrollView : NSObject <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *feedItemArray;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) UIScrollView *scrollViewController;

@property (nonatomic) int currIndex;
@property (nonatomic) int visibleView;


- (void) setup:(UIScrollView *)scrollView storyboard:(UIStoryboard *)storyboard identifier:(NSString *)identifier;
//- (void)scrollViewDidScroll:(UIScrollView *)sender;
//- (void)populateScrollView:(NSArray *)feedItemArray;

@end
