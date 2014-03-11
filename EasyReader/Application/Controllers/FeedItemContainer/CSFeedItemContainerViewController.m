//
//  CSFeedItemContainerViewController.m
//  EasyReader
//
//  Created by Michael Beattie on 3/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedItemContainerViewController.h"
#import "FeedItemViewController.h"

static NSString *kNameKey = @"nameKey";
static NSString *kImageKey = @"imageKey";

// Direction based increment
static const NSInteger LEFT = -1;
static const NSInteger RIGHT = 1;

// ControllerView ids
static const NSInteger PREV = 0;
static const NSInteger CURR = 1;
static const NSInteger NEXT = 2;

// View dimensions
static NSInteger HEIGHT;
static NSInteger WIDTH;

@interface CSFeedItemContainerViewController ()
@end

@implementation CSFeedItemContainerViewController
// currIndex is always the index at view CURR
// visibleView is the currently visible view

- (void)viewDidLoad
{
  [super viewDidLoad];

  // Set default index and view
  _currIndex = 1;
  _visibleView = PREV;
  
  // Define view height and width
  WIDTH = self.scrollViewController.frame.size.width;
  HEIGHT = self.scrollViewController.frame.size.height;
  
  // Initalize controller array
  _viewControllers = [[NSMutableArray alloc] init];
  
  // Create 3 ViewControllers inside of the controller array
  // Reposition views to have be left center and right
  for (NSInteger i = 0; i < 3; i++)
  {
    [_viewControllers addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"FeedItem"]];
    ((FeedItemViewController *) [_viewControllers objectAtIndex:i]).view.frame= CGRectMake(WIDTH*i, 0, WIDTH, HEIGHT);
  }
  
  // Load the content of the views
  [self loadPages];
  
  // Set the scrollView large enough to fit all 3 views
  self.scrollViewController.contentSize = CGSizeMake(WIDTH*3, HEIGHT);
  
  // Hide the horizontal navbar and enable paging
  [self.scrollViewController setShowsHorizontalScrollIndicator:NO];
  self.scrollViewController.pagingEnabled = YES;
  
  // Add each controllers view to the scrollView
  for (FeedItemViewController *controller in _viewControllers) {
    [self.scrollViewController addSubview:controller.view];
  }
  
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
//  // User scrolled right
//  if([self movingRight]){
//    
//    // Are we updating or moving the view
//    if([self movingVisibleViewRight]){
//      // Move the view
//      _visibleView = _visibleView+1;
//    }
//    else{
//      // Update view content
//      [self updateViews:RIGHT];
//    }
//  }
//  
//  // User scrolled left
//  else if([self movingLeft]){
//    if([self movingVisibleViewLeft]){
//      _visibleView --;
//    }
//    else{
//      [self updateViews:LEFT];
//    }
//  }
}

// Detect direction of motion
// >= and <= are used to keep views moving in case of fast scrolling
- (BOOL)movingRight
{
//  return ((self.scrollViewController.contentOffset.x == self.scrollViewController.frame.size.width && _visibleView == (int)PREV) ||
//          ((self.scrollViewController.contentOffset.x >= (self.scrollViewController.frame.size.width*2)) && _visibleView <= (int)CURR));
  return FALSE;
}

- (BOOL)movingLeft
{
//  return ((self.scrollViewController.contentOffset.x <= 0 && _visibleView >= (int)CURR) ||
//          (self.scrollViewController.contentOffset.x == self.scrollViewController.frame.size.width && _visibleView == (int)NEXT));
  return FALSE;
}

// Check if moving off of the first feedItem or moving to the last feedItem
- (BOOL)movingVisibleViewRight
{
//  return ((_currIndex == 1 && _visibleView == (int)PREV) ||
//          (_currIndex == (int)_feedItemArray.count-2 && _visibleView == (int)CURR));
  return FALSE;
}

// Check if moving off of the last feedItem or moving to the first feedItem
- (BOOL)movingVisibleViewLeft
{
//  return ((_currIndex == 1 && _visibleView == (int)CURR) ||
//          (_currIndex == (int)_feedItemArray.count-2 && _visibleView == (int)NEXT));
  return FALSE;
}

- (void)updateViews:(NSInteger)direction
{
//  // Update currIndex left or right
//  _currIndex += direction;
//  
//  [self loadPages];
//  
//  // Reposition scrollView to CURR view
//  [self.scrollViewController scrollRectToVisible:CGRectMake(WIDTH,0,WIDTH,HEIGHT) animated:NO];
}

- (void)loadPageWithId:(int)index onPage:(int)page {
//  if (index < (int)_feedItemArray.count) {
//    // Parse feedItem
//    NSDictionary *feedItem = [_feedItemArray objectAtIndex:index];
//    // Pass feedItem to feedItemViewController update method
//  }
}

- (void)loadPages {
  FeedItemViewController *controller = ((FeedItemViewController *) [_viewControllers objectAtIndex:0]);
  
  // Load feed info for each of the views
  controller.feedItemImage.image = [UIImage imageNamed:@""];
  controller = ((FeedItemViewController *) [_viewControllers objectAtIndex:1]);
  controller.feedItemImage.image = [UIImage imageNamed:@""];
  controller = ((FeedItemViewController *) [_viewControllers objectAtIndex:2]);
  controller.feedItemImage.image = [UIImage imageNamed:@""];
//	[self loadPageWithId:_currIndex - 1 onPage:PREV];
//  [self loadPageWithId:_currIndex onPage:CURR];
//  [self loadPageWithId:_currIndex + 1 onPage:NEXT];
}

@end