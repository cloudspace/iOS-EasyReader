//
//  CSFeedCreateViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/9/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

// Controllers
#import "CSFeedAddViewController.h"
#import  "CSRootViewController.h"

// Models
#import "Feed.h"
#import "User.h"


// Libraries
#import "MFSideMenu.h"
#import "CSAutoCompleteViewController.h"
#import "AFNetworking.h"


@implementation CSFeedAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  
  if (self)
  {
    self.hasNavigationBar = NO;

    // Load autocomplete controller
    self.autoCompleteController = [CSAutoCompleteViewController new];
    self.autoCompleteController.delegate = self;
    [self.autoCompleteController.view setFrame:CGRectMake(0, 0, 320, 320)];
    [self.view addSubview:self.autoCompleteController.view];
  }
  
  return self;
}


/**
 * Sets the field contents if available
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  if (self.feed)
  {
    [self.textField_name setText:self.feed.name];
    [self.textField_url  setText:self.feed.url];
  }
}

/**
 * Sets the right view sizes for the orientation and screen size (since the keyboard is showing)
 */
- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // Set the keyboard to show
  [self.autoCompleteController.searchBar becomeFirstResponder];
  
  // Fix size based on orientation
  if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
  {
    [self.autoCompleteController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 216)];
  }
  else
  {
    [self.autoCompleteController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 162)];
  }
}


/**
 * Dismisses the view controller
 */
- (void)cancel:(id)sender
{
  //[self.rootViewController.sideMenu setMenuState:MFSideMenuStateLeftMenuOpen];
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}

/**
 * Saves the current feed (or creates a new one) and dismisses the view controller
 */
- (void)save:(id)sender
{
  
  User *currentUser = [User current];
  
  Feed *currentFeed;
  
  if (self.feed)
  {
    currentFeed = self.feed;
    [currentUser willChangeValueForKey:@"feeds"];
  }
  else
  {
    currentFeed = [Feed createEntity];
  }
  
  currentFeed.name  = self.textField_name.text;
  currentFeed.url   = self.textField_url.text;
  currentFeed.user  = currentUser;
  
  currentUser.activeFeed = currentFeed;
  
  [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
  
  if (self.feed)
  {
    [currentUser didChangeValueForKey:@"feeds"];
  }
  
  
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}

#pragma mark - CSAutoCompleteDelegate Methods
/**
 * Fires a JSON request to get the feeds starting with the given name
 */
- (void) autoComplete:(CSAutoCompleteViewController *)viewController didChangeSearchTerm:(NSString *)searchTerm onComplete:(void (^)(NSArray *))setAutoCompleteData
{
  // Cancel any existing requests
  if (_requestOperation)
  {
    [_requestOperation cancel];
    _requestOperation = nil;
  }
  NSString *safeSearchTerm = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  
  NSString *url = [NSString stringWithFormat:@"%@/feeds?name=%@", host, safeSearchTerm];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  
  _requestOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    _requestOperation = nil;
    
    // Set the feed data if no errors
    
    NSMutableArray *feedNames = [NSMutableArray new];
    NSMutableArray *availableNewFeeds = [NSMutableArray new];
    
    BOOL exists;
    
    for (NSDictionary *feed in JSON[@"feeds"])
    {
      exists = NO;
      for (Feed *userFeed in [User current].feeds)
      {
        if ([userFeed.url isEqualToString:feed[@"url"]])
        {
          exists = YES;
          continue;
        }
      }
      
      if (!exists)
      {
        [feedNames addObject:feed[@"name"]];
        [availableNewFeeds addObject:feed];
      }
    }
    
    _availableFeeds = [availableNewFeeds copy];;
    
    setAutoCompleteData(@[
      @{
        @"title": @"Results",
        @"items": [feedNames copy],
        @"image": [UIImage imageNamed:@"button_add@2x.png"]
      }
     ]);
    
    
    
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
    _requestOperation = nil;
    setAutoCompleteData(@[]);
    
    //something went wrong
    NSLog(@"nooooooo");
    
    _requestOperation = nil;
  }];
  
  [_requestOperation start];
}

/**
 * Sets the recommended feeds list as the default feeds for the autocomplete
 */
- (void)autoComplete:(CSAutoCompleteViewController *)viewController loadDefaultList:(void (^)(NSArray *))setDefaultList
{
  setDefaultList(@[@{@"title": @"Recommended Feeds", @"items": @[@"There are no recommended feeds at this time."]}]);
}

- (void)autoComplete:(CSAutoCompleteViewController *)viewController didSelectImageAtIndexPath:(NSIndexPath *)indexPath
{
  NSDictionary *availableFeed = self.availableFeeds[indexPath.row];
  
  NSArray *existingFeeds = [Feed findByAttribute:@"url" withValue:availableFeed[@"url"]];
  User *currentUser = [User current];
  
  if ([existingFeeds count] > 0)
  {
    Feed *existingFeed = existingFeeds[0];
    if ([currentUser.feeds containsObject:existingFeed])
    {
      return;
    }
  }
  else
  {
    Feed *feed = [Feed createEntity];
    feed.name  = availableFeed[@"name"];
    feed.url   = availableFeed[@"url"];
    [currentUser addFeedsObject:feed];
    [currentUser setActiveFeed:feed];
  }
  
  
  [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
  
  [self.navigationController dismissViewControllerAnimated:YES completion:^{
    
  }];
}

/**
 * Cancels the add
 */
- (void)didPressCancelbuttonForAutoComplete:(CSAutoCompleteViewController *)viewController
{
  [self cancel:nil];
}

/**
 * Change autoCompleteController size on rotation
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  [UIView animateWithDuration:duration
                        delay:0
                      options: UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation))
                     {
                       [self.autoCompleteController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 216)];
                     }
                     else
                     {
                       [self.autoCompleteController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 162)];
                     }
                   }
                   completion:^(BOOL finished){
                     NSLog(@"Done!");
                   }];  
}


@end
