//
//  CSFeedItemContainerViewController.h
//  EasyReader
//
//  Created by Michael Beattie on 3/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSBaseViewController.h"

@interface CSFeedItemContainerViewController : CSBaseViewController  <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewController;

@property (nonatomic, strong) NSMutableArray *feedItemArray;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (nonatomic) int currIndex;
@property (nonatomic) int visibleView;

@end
