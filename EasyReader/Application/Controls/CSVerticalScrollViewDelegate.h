//
//  CSVerticalScrollViewDelegate.h
//  EasyReader
//
//  Created by Michael Beattie on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSFeedItemContainerViewController.h"
#import "CSFeedItemArticleViewController.h"

@interface CSVerticalScrollViewDelegate : NSObject <UIScrollViewDelegate>

@property (nonatomic, strong) UIStoryboard *storyboard;
@property (nonatomic, strong) UIScrollView *scrollViewController;
@property (nonatomic, strong) NSString *currentURL;
@property (nonatomic, strong) CSFeedItemContainerViewController *feedItemVC;
@property (nonatomic, strong) CSFeedItemArticleViewController *feedItemArticleVC;

- (id)initWithScrollView:(UIScrollView *)scrollView
              storyboard:(UIStoryboard *)storyboard
           andIdentifier:(NSString *)identifier;

@end
