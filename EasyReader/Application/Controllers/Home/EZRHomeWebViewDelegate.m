//
//  EZRHomeWebViewDelegate.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "EZRHomeWebViewDelegate.h"
#import "EZRHomeViewController.h"

@implementation EZRHomeWebViewDelegate
{
    EZRHomeViewController *controller;
}

- (instancetype)initWithController:(EZRHomeViewController *)homeController
{
    self = [super init];
    
    if (self)
    {
        controller = homeController;
    }
    
    return self;
}


//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
////    controller.scrollView_vertical.scrollEnabled = YES;
//    NSLog(@"enable scrolling on uiscrollview");
//}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    controller.scrollView_vertical.scrollEnabled = YES;
//    
//    if (scrollView.contentOffset.y == 0)
//    {
//        NSLog(@"YES");
//        
//    }
}

@end
