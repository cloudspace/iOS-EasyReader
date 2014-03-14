//
//  CSFeedItemContainerViewController.h
//  EasyReader
//
//  Created by Michael Beattie on 3/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Block-KVO/MTKObserving.h>
#import "CSBaseViewController.h"
#import "CSAppDelegate.h"
#import "User.h"
#import "Feed.h"
#import "CSHorizontalScrollView.h"

@interface CSFeedItemContainerViewController : CSBaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewController;

@property (nonatomic, strong) NSMutableSet *feedItemsSet;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (nonatomic) int currIndex;
@property (nonatomic) int visibleView;

@property User* currentUser;

@end
