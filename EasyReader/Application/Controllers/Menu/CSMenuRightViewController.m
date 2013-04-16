//
//  CSMenuRightViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSMenuRightViewController.h"
#import "CSBaseView.h"

@interface CSMenuRightViewController ()

@end

@implementation CSMenuRightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Set up the view
- (void)loadView
{
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  CSBaseView *view = [[CSBaseView alloc] initWithFrame:screenRect];
  
  [view setBackgroundColor:[UIColor greenColor]];
  
  self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
