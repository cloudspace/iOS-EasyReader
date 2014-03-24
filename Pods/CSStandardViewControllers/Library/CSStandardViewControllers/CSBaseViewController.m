//
//  CSBaseViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSBaseViewController.h"

@interface CSBaseViewController ()

@end

@implementation CSBaseViewController

/**
 * Automatically loads a xib based on the view controller class name with the 
 * CS prefix and ViewController strings removed
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  //
  // If no nib name is given attempt to auto-detect a nib
  //
  if (!nibNameOrNil)
  {
    // Get the base nib name
    NSString *className = NSStringFromClass([self class]);
    className = [className stringByReplacingOccurrencesOfString:@"ViewController" withString:@""];

    
    // Get the model
    NSString *deviceModel = [[UIDevice currentDevice] model];
    NSString *nibType;
    
    if ([deviceModel hasPrefix:@"iPhone"] || [deviceModel hasPrefix:@"iPod"])
    {
      // Use iPhone nibs
      nibType = @"iPhone";
    }
    else
    {
      // Use iPad nibs
      nibType = @"iPad";
    }
    
    // Get the final nib name and set it if it exists
    NSString *nibName = [NSString stringWithFormat:@"%@_%@", className, nibType];
    if ([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"])
    {
      nibNameOrNil = nibName;
      nibBundleOrNil = [NSBundle mainBundle];
      _shouldSetViewFrame = YES;
    }
  }
  
  // Init super
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  
  if (self) {
    // Default the views to having a navigation bar
    _hasNavigationBar = YES;
  }
  
  return self;
}

/**
 * Sets the default frame
 */
- (UIView *)view
{
  if (_shouldSetViewFrame)
  {
    [[super view] setFrame:[[UIApplication sharedApplication] delegate].window.screen.applicationFrame];
    _shouldSetViewFrame = NO;
  }
  return [super view];
}

- (void)setView:(UIView *)view
{
  [super setView:view];
}


/**
 * Shows or hides the nav bar when the view appears
 */
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  if (_hasNavigationBar)
  {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
  }
  else
  {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
  }
}

/**
 * Initializes a new view controller
 */
+ (id) new
{
  return [[[self class] alloc] initWithNibName:nil bundle:nil];
}

/**
 * Returns the root view controller
 */
- (id)rootViewController
{
  return [[[[UIApplication sharedApplication] delegate] window] rootViewController];
}

/**
 * Handles memory warnings
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
