//
//  CSHorizontalScrollView.m
//  EasyReader
//
//  Created by Michael Beattie on 3/13/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSHorizontalScrollView.h"
#import "FeedItemViewController.h"

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

@implementation CSHorizontalScrollView

- (id)initWithScrollView:(UIScrollView *)scrollView
              storyboard:(UIStoryboard *)storyboard
           andIdentifier:(NSString *)identifier
{
    self = [super init];
    if( !self ) return nil;
    
    _scrollViewController = scrollView;
    _storyboard = storyboard;
    
    // Set default index and view
    //_currIndex = 1;
    //_visibleView = PREV;
    [self setCurrentIndex:0];
  
    // Define dimensions of scrollView
    [self customizeScrollView];
    
    // Instatiate viewControllers
    [self initViewControllersWithIdentifier:identifier];
    
    // Add controllers to the scrollView
    [self initScrollViewWithControllers];
    
    return self;
}

- (void)customizeScrollView{
    // Define view height and width
    WIDTH = _scrollViewController.frame.size.width;
    HEIGHT = _scrollViewController.frame.size.height;
    
    // Set the scrollView large enough to fit all 3 views
    _scrollViewController.contentSize = CGSizeMake(WIDTH*3, HEIGHT);
    
    // Hide the horizontal navbar and enable paging
    [_scrollViewController setShowsHorizontalScrollIndicator:NO];
    _scrollViewController.pagingEnabled = YES;
}

- (void)initViewControllersWithIdentifier:(NSString *)identifier
{
    // Initalize controller array
    _viewControllers = [[NSMutableArray alloc] init];
    
    // Create 3 ViewControllers inside of the controller array
    // Reposition views to have be left center and right
    for (NSInteger i = 0; i < 3; i++)
    {
        [_viewControllers addObject:[_storyboard instantiateViewControllerWithIdentifier:identifier]];
        ((FeedItemViewController *) [_viewControllers objectAtIndex:i]).view.frame= CGRectMake(WIDTH*i, 0, WIDTH, HEIGHT);
    }
}

- (void)initScrollViewWithControllers
{
    // Add each controllers view to the scrollView
    for (FeedItemViewController *controller in _viewControllers) {
        [_scrollViewController addSubview:controller.view];
    }
}

//the currently viewed item is normally stored at currIndex
//if on the left or right edge, the visible view is changed
//left edge: currIndex = 1, visibleView = 0, return the element at (1 - 1)
//middle: currIndex = 5, visibleView = 1, return the element at (5 - 0)
//ridge edge: currIndex = length - 2, visibleView = 2, return the element at (length - 2 + 1)
- (FeedItem *) currentFeedItem
{
  return [_feedItemArray objectAtIndex:(_currIndex + (_visibleView - 1))];
}

//replace the old feed list with the new feed list and make sure the user stays on the same item even if it's location shifts
//
//save a reference to the currently viewed item
//update the list
//check the new list for the save item and set the current index
//if it isn't found, put the currently viewed item at the end of the list and update the current index
- (void)populateFeeds:(NSMutableSet *)feedItemSet
{
  FeedItem *currentItem = [self currentFeedItem];
  
  _feedItemArray = [[[feedItemSet allObjects] sortedArrayUsingSelector:@selector(compareUpdatedAt:)] mutableCopy];
  
  if (currentItem) {
    bool itemFound = false;
    for(int i = 0; i < _feedItemArray.count; i++) {
      if ( [_feedItemArray[i] id] == [currentItem id] ) {
        [self setCurrentIndex:i];
        itemFound = true;
      }
    }
    if (!itemFound) {
      [_feedItemArray addObject:currentItem];
      [self setCurrentIndex:_feedItemArray.count - 1];
      itemFound = true;
    }
  }
    // Load the content of the views
    [self loadPages];
  NSLog(@"hello");
}

//fun rules for setting the current index
//the edge cases require some explanation
//the current index references the index of feedItemsSet currently displayed by the middle feed item view (CURR)
//when you hit the edges of the feed items set, you move to the PREV or NEXT view without changing the view shown in the
//middle (CURR) view
//that is why the math looks a little weird with off by one changes
- (void) setCurrentIndex:(int)newIndex
{
  if(newIndex == 0) {
    _currIndex = 1;
    _visibleView = PREV;
  } else if(newIndex == _feedItemArray.count - 1) {
    _currIndex = _feedItemArray.count - 2;
    _visibleView = NEXT;
  } else {
    _currIndex = newIndex;
    _visibleView = CURR;
  }
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
            (_currIndex == (int)_feedItemArray.count-2 && _visibleView == (int)CURR));
}

// Check if moving off of the last feedItem or moving to the first feedItem
- (BOOL)movingVisibleViewLeft
{
    return ((_currIndex == 1 && _visibleView == (int)CURR) ||
            (_currIndex == (int)_feedItemArray.count-2 && _visibleView == (int)NEXT));
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
    if (index < (int)_feedItemArray.count) {
        FeedItemViewController *controller = ((FeedItemViewController *) [_viewControllers objectAtIndex:page]);
        FeedItem *feedItem = [_feedItemArray objectAtIndex:index];
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
