//
//  CSFeedItemContainerViewController.m
//  EasyReader
//
//  Created by Michael Beattie on 3/7/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedItemContainerViewController.h"
#import "FeedItemViewController.h"



@interface CSFeedItemContainerViewController ()
{
    CSHorizontalScrollView *scrollViewDelegate;
}

@end

@implementation CSFeedItemContainerViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  scrollViewDelegate = [[CSHorizontalScrollView alloc] initWithScrollView:self.scrollViewController
                                                               storyboard:[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]]
                                                            andIdentifier:@"FeedItem"];
  [self.scrollViewController setDelegate:scrollViewDelegate];

  _currentUser = [User current];
  _feedItemsSet = [[NSMutableSet alloc] init];

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
  
  [self observeRelationship:@keypath(self.currentUser.feeds)
                changeBlock:^(__weak CSFeedItemContainerViewController *self, NSSet *old, NSSet *new) {
                  NSMutableArray *addedFeeds = [[new allObjects] mutableCopy];
                  NSMutableArray *removedFeeds = [[old allObjects] mutableCopy];
                  
                  [addedFeeds removeObjectsInArray:[old allObjects]];
                  [removedFeeds removeObjectsInArray:[new allObjects]];
                  
                  for ( Feed *feed in removedFeeds ){
                    [feed removeAllObservations];
                  }
                  
                  for ( Feed *feed in addedFeeds ){
                    [feed observeRelationship:@"feedItems"
                                  changeBlock:^(__weak Feed *feed, NSSet *new, NSSet *old) {
                                    NSMutableArray *addedFeedItems;
                                    NSMutableArray *removedFeedItems;
                                    
                                    if( new != nil ){
                                      addedFeedItems = [[new allObjects] mutableCopy];
                                      removedFeedItems = [[old allObjects] mutableCopy];
                                      
                                      [addedFeedItems removeObjectsInArray:[old allObjects]];
                                      [removedFeedItems removeObjectsInArray:[new allObjects]];
                                    } else {
                                      addedFeedItems = [[old allObjects] mutableCopy];
                                      removedFeedItems = [[new allObjects] mutableCopy];
                                    }
                                    
                                    for ( FeedItem *item in removedFeedItems ){
                                      [item removeAllObservations];
                                    }
                                    
                                    for ( FeedItem *item in addedFeedItems ){
                                      [_feedItemsSet addObject:item];
                                    }
                                    
                                    [self loadPages];
                                  }
                               insertionBlock:nil
                                 removalBlock:nil
                             replacementBlock:nil];
                  }
                  
                  //properties:@[@"title", @"summary", @"updatedAt", @"publishedAt", @"createdAt", @"image", @"url"]
                }
             insertionBlock:nil
               removalBlock:nil
           replacementBlock:nil
   ];
  
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
  // User scrolled right
  if([self movingRight]){
    
    // Are we updating or moving the view
    if([self movingVisibleViewRight]){
      // Move the view
      _visibleView = _visibleView+1;
    }
    else{
      // Update view content
      [self updateViews:RIGHT];
    }
  }
  
  // User scrolled left
  else if([self movingLeft]){
    if([self movingVisibleViewLeft]){
      _visibleView --;
    }
    else{
      [self updateViews:LEFT];
    }
  }
}

// Detect direction of motion
// >= and <= are used to keep views moving in case of fast scrolling
- (BOOL)movingRight
{
  return ((self.scrollViewController.contentOffset.x == self.scrollViewController.frame.size.width && _visibleView == (int)PREV) ||
          ((self.scrollViewController.contentOffset.x >= (self.scrollViewController.frame.size.width*2)) && _visibleView <= (int)CURR));
}

- (BOOL)movingLeft
{
  return ((self.scrollViewController.contentOffset.x <= 0 && _visibleView >= (int)CURR) ||
          (self.scrollViewController.contentOffset.x == self.scrollViewController.frame.size.width && _visibleView == (int)NEXT));
}

// Check if moving off of the first feedItem or moving to the last feedItem
- (BOOL)movingVisibleViewRight
{
  return ((_currIndex == 1 && _visibleView == (int)PREV) ||
          (_currIndex == (int)_feedItemsSet.count-2 && _visibleView == (int)CURR));
}

// Check if moving off of the last feedItem or moving to the first feedItem
- (BOOL)movingVisibleViewLeft
{
  return ((_currIndex == 1 && _visibleView == (int)CURR) ||
          (_currIndex == (int)_feedItemsSet.count-2 && _visibleView == (int)NEXT));
}

- (void)updateViews:(NSInteger)direction
{
  // Update currIndex left or right
  _currIndex += direction;
  
  [self loadPages];
  
  // Reposition scrollView to CURR view
  [self.scrollViewController scrollRectToVisible:CGRectMake(WIDTH,0,WIDTH,HEIGHT) animated:NO];
}

- (void)loadPageWithId:(int)index onPage:(int)page {
  if (index < (int)_feedItemsSet.count) {
    FeedItemViewController *controller = ((FeedItemViewController *) [_viewControllers objectAtIndex:page]);
    FeedItem *feedItem = [[_feedItemsSet allObjects] objectAtIndex:index];
    [controller updateFeedItemInfo:feedItem];
  }
}

- (void)loadPages {
  // Load feed info for each of the views
	[self loadPageWithId:_currIndex - 1 onPage:PREV];
  [self loadPageWithId:_currIndex onPage:CURR];
  [self loadPageWithId:_currIndex + 1 onPage:NEXT];
}

@end