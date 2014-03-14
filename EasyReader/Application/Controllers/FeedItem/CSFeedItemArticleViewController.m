//
//  CSFeedItemArticleViewController.m
//  EasyReader
//
//  Created by Michael Beattie on 3/14/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedItemArticleViewController.h"

@interface CSFeedItemArticleViewController ()

@end

@implementation CSFeedItemArticleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *fullURL = @"http://www.CNN.com";
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [_articleWebView loadRequest:requestObj];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
