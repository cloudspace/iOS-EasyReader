//
//  CSHomeViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSHomeViewController.h"
#import "CSRootViewController.h"
#import "CSFeedItemViewController.h"


#import "UIImageView+WebCache.h"
#import "MTLabel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "AFNetworking.h"
#import "SDWebImagePrefetcher.h"

#import "CSEnhancedTableView.h"
#import "CSEnhancedTableViewCell.h"
#import "CSEnhancedTableViewHeaderFooterView.h"

#import "User.h"
#import "Feed.h"
#import "FeedSort.h"




@interface CSHomeViewController ()

@end

@implementation CSHomeViewController


/**
 * Loads the default rss feeds and creates feed objects in core data
 */
- (void) loadDefaultFeeds
{
  
  // Build Request
  NSString *url = [NSString stringWithFormat:@"%@/feeds", host];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  
  [self.tableView_feed setShowsPullToRefresh:NO];
  
  // Show loading indicator
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.labelText = @"Loading Feeds";
  
  // Execute and parse the request
  [[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tableView_feed setShowsPullToRefresh:YES];
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    
    User *currentUser = [User current];
    
    // Create default feeds
    for (NSDictionary *feedData in JSON[@"feeds"])
    {
      Feed *feed = [Feed MR_createEntity];
      feed.name = feedData[@"name"];
      feed.url  = feedData[@"url"];
      
      FeedSort *sort = [FeedSort MR_createEntity];
      sort.user = currentUser;
      sort.feed = feed;
      
      [currentUser addFeedsObject:feed];
    }
    
    // Set the first feed as active
    if ([currentUser.feeds count] > 0)
    {
      [currentUser setActiveFeed:[currentUser.feeds allObjects][0]];
    }
    
    // Mark database as seeded
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:YES] forKey:@"seeded"];
    
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tableView_feed setShowsPullToRefresh:YES];
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    
    //something went wrong
    NSLog(@"nooooooo feeds");
    
  }] start];
  
}

/**
 * Sets up the menu button, observers, pull-to-refresh, and infinite scrolling
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Create defaults if doesn't exist
  if (![[NSUserDefaults standardUserDefaults] valueForKey:@"visitedURLs"])
  {
    [[NSUserDefaults standardUserDefaults] setValue:[[NSMutableArray alloc] init] forKey:@"visitedURLs"];
  }
  
  self.currentUser = [User current];
  
  //
  // Register observers
  //
  [self.currentUser addObserver:self forKeyPath:@"activeFeed" options:NSKeyValueObservingOptionOld context:nil];
  [self addObserver:self forKeyPath:@"feedData" options:NSKeyValueObservingOptionNew context:nil];
  
  
  //
  // Add toolbar buttons
  //
  UIButton *buttonMenu = [UIButton buttonWithType:UIButtonTypeCustom];
  [buttonMenu setFrame:CGRectMake(0, 0, 44, 44)];
  [buttonMenu addTarget:self.rootViewController action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
  [buttonMenu setImage:[UIImage imageNamed:@"button_menu@2x.png"] forState:UIControlStateNormal];

  [buttonMenu.imageView setContentMode:UIViewContentModeScaleAspectFit];
  [buttonMenu setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin];

  self.feedLimit = 10;
  self.feedOffset = 0;
  
  self.barButton_menu = [[UIBarButtonItem alloc] initWithCustomView:buttonMenu];
  [self.navigationItem setLeftBarButtonItem:self.barButton_menu];
  
  // Set up back buttons that point to this view
  UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
  self.navigationItem.backBarButtonItem = backButton;
  
  
  // Set up pull-to-refresh on tableview
  __weak CSHomeViewController *weakHomeController = self;
  [self.tableView_feed addPullToRefreshWithActionHandler:^{
    if (weakHomeController.currentUser.activeFeed)
    {
      [weakHomeController downloadFeedData:weakHomeController.currentUser.activeFeed];
    }
  }];
  
  // Set up infinite scrolling on tableview
  [self.tableView_feed addInfiniteScrollingWithActionHandler:^{
    if (weakHomeController.currentUser.activeFeed)
    {
      weakHomeController.feedOffset += 10;
      [weakHomeController downloadFeedData:weakHomeController.currentUser.activeFeed limit:weakHomeController.feedLimit offset:weakHomeController.feedOffset];
    }
  }];
  
  
  // Download either the active feed or the default feeds
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (![[defaults valueForKey:@"seeded"] isEqual:[NSNumber numberWithBool:YES]])
  {
    [self loadDefaultFeeds];
  }
  else
  {
    [[User current] activeFeed];  // Enough to trigger KVO
//    [self downloadFeedData:activeFeed];
  }
  
  return;
}

/**
 * Cancels image prefetching when the view disappears
 */
- (void)viewDidDisappear:(BOOL)animated
{
  [[SDWebImagePrefetcher sharedImagePrefetcher] cancelPrefetching];
  [super viewDidDisappear:animated];
}

/**
 * Removes all observers
 */
- (void)dealloc
{
  [self.currentUser removeObserver:self forKeyPath:@"activeFeed"];
  [self removeObserver:self forKeyPath:@"feedData"];
  
}

/**
 * Observes values changes on feedData and activeFeed
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if ([keyPath isEqualToString:@"feedData"])
  {
    [self processFeedData];
  }
  else if ([keyPath isEqualToString:@"activeFeed"])
  {
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.feedOffset = 0;
    [self.tableView_feed setShowsInfiniteScrolling:YES];
    if (_requestOperation)
    {
      [_requestOperation cancel];
      _requestOperation = nil;
      [self.tableView_feed.pullToRefreshView stopAnimating];
    }
    
    // If the new feed is not the same as it used to be, load it
    Feed *newFeed = [[User current] activeFeed];
    
    if (![change[@"old"] isEqual:newFeed])
    {
      self.feedData = @[];

      // Show loading indicator
      [self.tableView_feed.pullToRefreshView startAnimating];

      // Download new data
      [self downloadFeedData:newFeed];      
    }
  }
}

/**
 * Get the newest data from the RSS feed
 */
- (void) downloadFeedData:(Feed *)activeFeed
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
  {
    [self downloadFeedData:activeFeed limit:20 offset:0];
  }
  else
  {
    [self downloadFeedData:activeFeed limit:10 offset:0];
  }

}


/**
 * Get the data from the RSS feed
 */
- (void) downloadFeedData:(Feed *)activeFeed limit:(NSInteger)limit offset:(NSInteger)offset
{
  if (!$exists(activeFeed)) return;
  
  // Build a request
  [self.navigationItem setTitle:[NSString stringWithFormat:@"%@", activeFeed.name]];
  
  NSString *url = [NSString stringWithFormat:@"%@/feeds?url=%@&limit=%d&offset=%d", host, activeFeed.url, limit, offset];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  
  // Execute and parse the request
  _requestOperation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    dispatch_async(dispatch_get_main_queue(), ^{
      //[MBProgressHUD hideAllHUDsForView:self.tableView_feed animated:YES];
      [self.tableView_feed.pullToRefreshView stopAnimating];
      [self.tableView_feed.infiniteScrollingView stopAnimating];
    });
    
    NSMutableArray *newFeedItems = [NSMutableArray new];
    
    // Set the feed data if no errors
    if (!self.feedData)
    {
      [self setFeedData:JSON];
    }
    else
    {
      for (NSDictionary *currentFeedItem in JSON)
      {
        BOOL exists = NO;
        
        for (NSDictionary *feedItem in self.feedData)
        {
          if ([feedItem[@"id"] isEqual:currentFeedItem[@"id"]])
          {
            exists = YES;
            break;
          }
        }

        if (!exists)
        {
          [newFeedItems addObject:currentFeedItem];
        }
      }
      
      [self setFeedData:[[[NSMutableArray arrayWithArray:self.feedData] arrayByAddingObjectsFromArray:newFeedItems] copy]];
    }
    
    if ([JSON count] == 0)
    {
      [self.tableView_feed setShowsInfiniteScrolling:NO];
    }
    
    _requestOperation = nil;
    
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    dispatch_async(dispatch_get_main_queue(), ^{
      //[MBProgressHUD hideAllHUDsForView:self.tableView_feed animated:YES];
      [self.tableView_feed.pullToRefreshView stopAnimating];
    });
    
    //something went wrong
    NSLog(@"nooooooo");
    
    _requestOperation = nil;
  }];
  
  [_requestOperation start];
}

/**
 * Processes the downloaded feed data
 *
 * Seperates the items into groups by dates and makes day-based sections in the table
 */
- (void) processFeedData
{
  //
  // Seperate feed items by pubDate
  //
  NSDateFormatter *displayDateFormat = [[NSDateFormatter alloc] init];
  [displayDateFormat setDateFormat:@"EEEE, MMMM d, yyyy"];
  
  NSDateFormatter *feedDateFormat = [[NSDateFormatter alloc] init];
  [feedDateFormat setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
  
  NSMutableDictionary *feeds = [NSMutableDictionary new];
  NSMutableArray *days = [NSMutableArray new];
  
  
  NSMutableArray *urlsToPrefetch = [NSMutableArray new];
  
  for (NSDictionary *item in self.feedData)
  {
    // Prefetch image
    NSString *thumbnailURL = [NSString stringWithFormat:@"%@/feed_items/%@/thumbnail", host, item[@"id"]];
    [urlsToPrefetch addObject:[NSURL URLWithString:thumbnailURL]];
    
    if ([item[@"published"] isNull])
    {
      if (![[feeds allKeys] containsObject:@"Recent"])
      {
        feeds[@"Recent"] = [NSMutableArray new];
        [days addObject:@"Recent"];
      }
      [feeds[@"Recent"] addObject:item];
      continue;
    }
    
    NSDate *pubDate = [feedDateFormat dateFromString:item[@"published"]];
    NSString *dateString = [displayDateFormat stringFromDate:pubDate];
    
    if ([[feeds allKeys] containsObject:dateString])
    {
      [feeds[dateString] addObject:item];
    }
    else
    {
      feeds[dateString] = [@[item] mutableCopy];
      [days addObject:dateString];
    }
  }
  
  [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:[urlsToPrefetch copy]];
  
  // Loop through keys and add the arrays of objects to keep the order right
  NSMutableArray *__feedsByDay = [NSMutableArray new];
  
  for (NSString *dateString in days)
  {
    [__feedsByDay addObject:@{@"date": dateString, @"items": feeds[dateString]}];
  }
  
  self.feedsByDay = [__feedsByDay copy];
  [self.tableView_feed reloadData];
}

/**
 * Reloads the table data when the devices is turned
 */
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
  [self.tableView_feed reloadData];
}

#pragma mark - UITableViewDataSource Methods
/**
 * Number of sections in the tableView
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.feedsByDay count];
}

/**
 * Number of rows in each section
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.feedsByDay[section][@"items"] count];
}

/**
 * Height of the header in each section
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 30;
}

/**
 * Height of all the cells
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 54;
}

/**
 * Generates a view for the header in each section
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  //
  CSEnhancedTableViewHeaderFooterView* header = [self.tableView_feed dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
  
  // Set the label text
  [header.titleLabel setText:self.feedsByDay[section][@"date"]];
  
  return header;
}

/**
 * Generates a view for the cell for a given index path
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Get the RSS item related to this cell's position
  NSDictionary *item = self.feedsByDay[indexPath.section][@"items"][indexPath.row];
  
  // Dequeue a reusable cell
  CSEnhancedTableViewCell *cell = (CSEnhancedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"feedItem"];
  [cell setOpaque:YES];
  
  if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"visitedURLs"] containsObject:item[@"url"]])
  {
    [cell.textLabel setTextColor:[UIColor lightGrayColor]];
  }
  else
  {
    [cell.textLabel setTextColor:[UIColor darkGrayColor]];
  }
  
  // Set the cell's properties
  [cell.textLabel setText:item[@"name"]];
  
  
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  NSString *thumbnailURL = [NSString stringWithFormat:@"%@/feed_items/%@/thumbnail", host, item[@"id"]];
  
  
  cell.imageView.layer.cornerRadius = 4;
  cell.imageView.layer.masksToBounds = YES;
  [cell.imageView setImageWithURL:[NSURL URLWithString:thumbnailURL] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
  // Return the cell
  return cell;
}

#pragma mark - UITableViewDelegate Methods
/**
 * Launches a CSFeedItemViewController with the page set to the RSS/atom link
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *item = self.feedsByDay[indexPath.section][@"items"][indexPath.row];
  
  CSFeedItemViewController *feedItemController = [CSFeedItemViewController new];
  
  feedItemController.destinationUrl = item[@"url"];
  
  feedItemController.title = item[@"name"];
  [feedItemController setTitle:self.navigationItem.title];
  
  [self.navigationController pushViewController:feedItemController animated:YES];
  
  if ($exists(item[@"readability_content"]))
  {
    [feedItemController.webView loadHTMLString:item[@"readability_content"] baseURL:nil];
  }
  else
  {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:item[@"url"]]];
    
    [feedItemController.webView loadRequest:request];
  }

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSMutableArray *visitedURLs = [[defaults valueForKey:@"visitedURLs"] mutableCopy];
  
  if (![visitedURLs containsObject:item[@"url"]])
  {
    [visitedURLs addObject:item[@"url"]];
    [defaults setValue:[visitedURLs copy] forKey:@"visitedURLs"];
    [defaults synchronize];
  }
  
  [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
  

}


@end
