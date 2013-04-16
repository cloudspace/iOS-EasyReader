//
//  CSHomeViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/4/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSHomeViewController.h"
#import "CSBaseView.h"
#import "CSFeedItemView.h"
#import "CSFeedItemViewController.h"

//#import "RSSParser.h"
#import "TFHpple.h"
#import "UIImageView+WebCache.h"
#import "MTLabel.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "EGORefreshTableHeaderView.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "CSRootViewController.h"
#import "User.h"
#import "Feed.h"

#import "AFNetworking.h"
//#import <RestKit/RestKit.h>
//#import <RestKit/CoreData.h>

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


- (void)viewDidLoad
{
  [super viewDidLoad];
  //
  // Set up the table view's properties
  //
  
  [self.tableView_feed registerClass:[CSFeedItemView class] forCellReuseIdentifier:@"feedItem"];
  [self.tableView_feed setSeparatorColor:[UIColor colorWithWhite:.84 alpha:1.0]];
  
  
  
  
  
  
//  RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:baseURL];
//  [RKObjectManager setSharedManager:objectManager];
//  
////  [[RKObjectManager sharedManager] getObject:@"Feeds" path:@"feeds" parameters:@{} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
////    NSLog(@"YES");
////  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
////    NSLog(@"NO");
////  }];
//  
//  
//  RKObjectMapping *feedMapping = [RKObjectMapping mappingForClass:[Feed class]];
//  [feedMapping addAttributeMappingsFromDictionary:@{
//    @"name" : @"name"
//  }];
//
//  RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:feedMapping
//                                                                                      pathPattern:nil
//                                                                                          keyPath:@"feeds"
//                                                                                      statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
//  
//  [objectManager addResponseDescriptor:responseDescriptor];
//  
//  [objectManager getObjectsAtPath:@"feeds"
//                       parameters:nil
//                          success:^(RKObjectRequestOperation * operaton, RKMappingResult *mappingResult)
//   {
//     NSLog(@"success: mappings: %@", mappingResult);
//   }
//     failure:^(RKObjectRequestOperation * operaton, NSError * error)
//   {
//     NSLog (@"failure: operation: %@ \n\nerror: %@", operaton, error);
//   }];
  
  
  self.currentUser = [User current];

  //
  // Register observers
  //
  [self.currentUser addObserver:self forKeyPath:@"activeFeed" options:NSKeyValueObservingOptionNew context:nil];
  [self addObserver:self forKeyPath:@"feedData" options:NSKeyValueObservingOptionNew context:nil];
  
  
  //
  // Add toolbar buttons
  //
  UIButton *buttonMenu = [UIButton buttonWithType:UIButtonTypeCustom];
  [buttonMenu setFrame:CGRectMake(0, 0, 44, 44)];
  [buttonMenu addTarget:self.rootViewController action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
  [buttonMenu setBackgroundImage:[UIImage imageNamed:@"Images/Buttons/button_menu@2x.png"] forState:UIControlStateNormal];
  
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
  
  //
  // Download feed data
  //
//  if (self.currentUser.activeFeed)
//  {
//    [self downloadFeedData:self.currentUser.activeFeed];
//  }
  
  return;
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
    }
    
    self.feedData = @[];
    [self downloadFeedData:change[@"new"]];
  }
}

/**
 * Get the data from the RSS feed
 */
- (void) downloadFeedData:(Feed *)activeFeed
{
  if (!activeFeed || [activeFeed isKindOfClass:[NSNull class]]) return;
  // Build a request
  [self.navigationItem setTitle:[NSString stringWithFormat:@"%@", activeFeed.name]];
  
  NSString *url = [NSString stringWithFormat:@"http://33.33.33.107:3000/feeds?url=%@", activeFeed.url];

  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  
  // Show loading indicator
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView_feed animated:YES];
  hud.labelText = @"Loading";
  
  
  // Execute and parse the request
  _requestOperation =[AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [MBProgressHUD hideAllHUDsForView:self.tableView_feed animated:YES];
      [self.tableView_feed.pullToRefreshView stopAnimating];
    });
    
    // Set the feed data if no errors
    [self setFeedData:JSON];
    
    _requestOperation = nil;
    
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [MBProgressHUD hideAllHUDsForView:self.tableView_feed animated:YES];
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
    if (!item[@"published"])
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
  return 50;
}

/**
 * Generates a view for the header in each section
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  //
  // Create the header view (we aren't using reusable headers because the labels can't have
  // Their text label properties changed
  //
  UIView* header = [[UIView alloc] init];
  
  NSInteger headerWidth = tableView.frame.size.width;
  NSInteger headerHeight = [self tableView:tableView heightForHeaderInSection:section];
  

  //
  // Add background gradient to header
  //
  UIColor *backgroundGradientTop =    [UIColor colorWithWhite:.874f alpha:1.0];
  UIColor *backgroundGradientBottom = [UIColor colorWithWhite:.905f alpha:1.0];
  
  UIView *newBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerWidth, headerHeight)];
  CAGradientLayer *gradient = [CAGradientLayer layer];
  gradient.frame = newBackgroundView.bounds;
  gradient.colors = [NSArray arrayWithObjects:(id)[backgroundGradientTop CGColor], (id)[backgroundGradientBottom CGColor], nil];
  [newBackgroundView.layer addSublayer:gradient];
  
  [header addSubview:newBackgroundView];
  
  
  //
  // Create a label to hold the text content, make the label fit relatively well in the frame
  //
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerWidth, headerHeight)];
  label.frame = CGRectMake(0, 5, tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section]-5);
  
  // Set the label text
  [label setText:self.feedsByDay[section][@"date"]];
  
  // Set the label style
  label.backgroundColor = [UIColor clearColor];
  [label setTextAlignment:NSTextAlignmentCenter];
  label.font =[UIFont fontWithName:@"Avenir-Medium" size:13.0f];
  [label setTextColor:[UIColor colorWithWhite:.46 alpha:1.0]];
  
  // Add the label to the header content view
  [header addSubview:label];
  
  
  //
  // Add Line Views
  //
  UIView *lineViewTop1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerWidth, 1)];
  lineViewTop1.backgroundColor = [UIColor colorWithWhite:214/255.0 alpha:1.0];
  [header addSubview:lineViewTop1];
  
  UIView *lineViewTop2 = [[UIView alloc] initWithFrame:CGRectMake(0, 1, headerWidth, 1)];
  lineViewTop2.backgroundColor = [UIColor colorWithWhite:224/255.0 alpha:1.0];
  [header addSubview:lineViewTop2];
  
  UIView *lineViewBottom1 = [[UIView alloc] initWithFrame:CGRectMake(0, headerHeight-1, headerWidth, 1)];
  lineViewBottom1.backgroundColor = [UIColor colorWithWhite:224/255.0 alpha:1.0];
  [header addSubview:lineViewBottom1];
  
  UIView *lineViewBottom2 = [[UIView alloc] initWithFrame:CGRectMake(0, headerHeight, headerWidth, 1)];
  lineViewBottom2.backgroundColor = [UIColor colorWithWhite:214/255.0 alpha:1.0];
  [header addSubview:lineViewBottom2];
  
  // Return the header
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
  CSFeedItemView *cell = (CSFeedItemView *)[tableView dequeueReusableCellWithIdentifier:@"feedItem"];
  
  // Set the cell's properties
  [cell.label_title setText:item[@"name"]];
  [cell.label_description setText:item[@""]];
  if (item[@"readability_image"])
  {
    [cell.imageView setHidden:NO];
    [cell.imageView setImageWithURL:item[@"readability_image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
      //NSLog(@"%@", cell);
      //[self.tableView_feed reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
      
      //// Call begin and end updates to animate height changes and re-lay out the changed cells
      //[self.tableView_feed beginUpdates];
      //[self.tableView_feed endUpdates];
    }];
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
  
  NSString* templatePath = [[NSBundle mainBundle] pathForResource:@"FeedItemTemplate" ofType:@"html"];
  NSString* template = [NSString stringWithContentsOfFile:templatePath
                                                encoding:NSUTF8StringEncoding
                                                   error:NULL];
  
  [self.navigationController pushViewController:feedItemController animated:YES];
  NSString *htmlString = [NSString stringWithFormat:template, item[@"name"], item[@"readability_image"], item[@"readability_content"]];
  [feedItemController.webView loadHTMLString:htmlString baseURL:nil];
//  [feedItemController loadBrowser:[NSURL URLWithString:item[@"url"]]];
}


@end
