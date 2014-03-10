//
//  CSFeedItemContainerViewController.h
//  EasyReader
//
//  Created by Michael Beattie on 3/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSFeedItemContainerViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *feedItemArray;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic) int currIndex;
@property (nonatomic) int visibleView;

- (BOOL)movingRight;
- (BOOL)movingLeft;
- (BOOL)movingVisibleViewRight;
- (BOOL)movingVisibleViewLeft;

- (void)updateViews:(NSInteger)direction;
//- (void)loadPageWithId:(int)index onPage:(int)page;

@end
