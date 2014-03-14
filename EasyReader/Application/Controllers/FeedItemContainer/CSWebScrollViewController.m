//
//  CSWebScrollViewController.m
//  EasyReader
//
//  Created by Michael Beattie on 3/14/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSWebScrollViewController.h"

@interface CSWebScrollViewController ()
{
    CSVerticalScrollViewDelegate *scrollViewDelegate;
}
@end

@implementation CSWebScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    scrollViewDelegate = [[CSVerticalScrollViewDelegate alloc] initWithScrollView:self.scrollViewController
                                                                 storyboard:[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]]
                                                              andIdentifier:@"Container"];
    [self.scrollViewController setDelegate:scrollViewDelegate];
}

@end
