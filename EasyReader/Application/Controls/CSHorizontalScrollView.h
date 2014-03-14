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

@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSMutableArray *feedItemArray;
@property (nonatomic, strong) UIScrollView *scrollViewController;
@property (nonatomic, strong) UIStoryboard *storyboard;

@property (nonatomic) int currIndex;
@property (nonatomic) int visibleView;


- (id)initWithScrollView:(UIScrollView *)scrollView
              storyboard:(UIStoryboard *)storyboard
           andIdentifier:(NSString *)identifier;

- (void)populateFeeds:(NSMutableSet *)feedItemSet;

@end
