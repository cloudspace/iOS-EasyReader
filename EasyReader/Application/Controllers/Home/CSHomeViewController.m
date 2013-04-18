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
#import "AFNetworking.h"

#import "CSStyledTableView.h"
#import "CSStyledTableViewCell.h"
#import "CSStyledTableViewHeaderFooterView.h"

#import "User.h"
#import "Feed.h"





@interface CSHomeViewController ()

@end

@implementation CSHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    //self.hasNavigationBar = NO;
    // Custom initialization
  }
  return self;
}

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
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    
    // Create default feeds
    for (NSDictionary *feedData in JSON[@"feeds"])
    {
      Feed *feed = [Feed createEntity];
      feed.name = feedData[@"name"];
      feed.url  = feedData[@"url"];
      [[User current] addFeedsObject:feed];
    }
    
    // Set the first feed as active
    Feed *firstFeed = [Feed findAll][0];
    if (firstFeed)
    {
      [firstFeed setIsActiveFor:[User current]];
    }
    
    // Mark database as seeded
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithBool:YES] forKey:@"seeded"];
    
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    
    //something went wrong
    NSLog(@"nooooooo feeds");
    
  }] start];
  
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
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
  [buttonMenu setBackgroundImage:[UIImage imageNamed:@"button_menu@2x.png"] forState:UIControlStateNormal];
  
  self.barButton_menu = [[UIBarButtonItem alloc] initWithCustomView:buttonMenu];
  [self.navigationItem setLeftBarButtonItem:self.barButton_menu];
  
  //
  // Set up pull-to-refresh on tableview
  //
  __weak CSHomeViewController *weakHomeController = self;
  [self.tableView_feed addPullToRefreshWithActionHandler:^{
    if (weakHomeController.currentUser.activeFeed)
    {
      [weakHomeController downloadFeedData:weakHomeController.currentUser.activeFeed];
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
    Feed *activeFeed = [[User current] activeFeed];
    [self downloadFeedData:activeFeed];
  }
  
  return;
}

/**
 * Load default feeds on first appearance
 */
- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  

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
      //[self.tableView_feed triggerPullToRefresh];
      [self downloadFeedData:newFeed];      
    }
  }
}

/**
 * Get the data from the RSS feed
 */
- (void) downloadFeedData:(Feed *)activeFeed
{
  if (!$exists(activeFeed)) return;
  
  // Build a request
  [self.navigationItem setTitle:[NSString stringWithFormat:@"%@", activeFeed.name]];
  
  NSString *url = [NSString stringWithFormat:@"%@/feeds?url=%@", host, activeFeed.url];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  
  // Show loading indicator
  [self.tableView_feed.pullToRefreshView startAnimating];
  
  // Execute and parse the request
  _requestOperation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    dispatch_async(dispatch_get_main_queue(), ^{
      //[MBProgressHUD hideAllHUDsForView:self.tableView_feed animated:YES];
      [self.tableView_feed.pullToRefreshView stopAnimating];
    });
    
    // Set the feed data if no errors
    [self setFeedData:JSON];
    
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
  
  for (NSDictionary *item in self.feedData)
  {
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
  CSStyledTableViewHeaderFooterView* header = [self.tableView_feed dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
  
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
  CSStyledTableViewCell *cell = (CSStyledTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"feedItem"];
  
  // Set the cell's properties
  [cell.textLabel setText:item[@"name"]];
  
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  if (item[@"readability_image"])
  {
    [cell.imageView setHidden:NO];
    
    cell.imageView.layer.cornerRadius = 4;
    cell.imageView.layer.masksToBounds = YES;
    [cell.imageView setImageWithURL:item[@"image"] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
  }
  else
  {
    [cell.imageView setHidden:YES];
    cell.imageView.image = nil;
  }
  
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
  feedItemController.title = item[@"name"];
  
  [self.navigationController pushViewController:feedItemController animated:YES];
  NSString *htmlString = item[@"readability_content"];
  [feedItemController.webView loadHTMLString:htmlString baseURL:nil];
  
}


@end
