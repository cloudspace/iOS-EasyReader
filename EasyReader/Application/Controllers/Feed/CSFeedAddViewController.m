//
//  CSFeedAddViewController.m
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
#import "FeedSort.h"

// Libraries
#import "MFSideMenu.h"
#import "MBProgressHUD.h"
#import "CSAutoCompleteViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation CSFeedAddViewController

/**
 * Sets up the autocomplete controller
 */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  
  if (self)
  {
    self.hasNavigationBar = NO;

    // Load autocomplete controller
    self.autoCompleteController = [CSAutoCompleteViewController new];
    self.autoCompleteController.delegate = self;
    //[self.autoCompleteController.view setClipsToBounds:YES];

  }
  
  return self;
}


/**
 * Sets the field contents if available
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self.autoCompleteController.view setFrame:CGRectMake(0, 0, 320, 320)];
  [self.view addSubview:self.autoCompleteController.view];
  if (self.feed)
  {
    [self showAddCustomFeedForm];
    [self.textFieldName setText:self.feed.name];
    [self.textFieldURL  setText:self.feed.url];
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
  
  
  _requestOperation = [[AFHTTPRequestOperation alloc]
                       initWithRequest:request];
  _requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
  CSFeedAddViewController __weak *__self = self;
  [_requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
    __self.requestOperation = nil;
    
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
    
    __self.availableFeeds = [availableNewFeeds copy];;
    
    setAutoCompleteData(@[
                          @{
                            @"title": @"Results",
                            @"items": [feedNames copy],
                            @"image": [UIImage imageNamed:@"button_add@2x.png"]
                            }
                          ]);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    __self.requestOperation = nil;
    setAutoCompleteData(@[]);
    
    //something went wrong
    NSLog(@"nooooooo");
    
    __self.requestOperation = nil;
  }];
  
  [_requestOperation start];
}

/**
 * Sets the recommended feeds list as the default feeds for the autocomplete
 */
- (void)autoComplete:(CSAutoCompleteViewController *)viewController loadDefaultList:(void (^)(NSArray *))setDefaultList
{
  // If default data already exists, use it
  if (_defaultData)
  {
    setDefaultList(_defaultData);
  }
  
  // Load default data
  NSString *url = [NSString stringWithFormat:@"%@/feeds/recommended", host];
  
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  
  [MBProgressHUD showHUDAddedTo:self.autoCompleteController.view animated:YES];
  
  _requestOperation = [[AFHTTPRequestOperation alloc]
                       initWithRequest:request];
  _requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
  CSFeedAddViewController __weak *__self = self;
  [_requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id JSON) {
    // Remove request operation and hide HUD
    __self.requestOperation = nil;
    [MBProgressHUD hideAllHUDsForView:__self.autoCompleteController.view animated:YES];
    
    // Set the feed data if no errors
    NSMutableArray *feedNames = [NSMutableArray new];
    NSMutableArray *availableNewFeeds = [NSMutableArray new];
    
    for (NSDictionary *feed in JSON[@"feeds"])
    {
      [feedNames addObject:feed[@"name"]];
      [availableNewFeeds addObject:feed];
    }
    
    __self.availableFeeds = [availableNewFeeds copy];;
    
    setDefaultList(@[
                     @{
                       @"title": @"Recommended Feeds",
                       @"items": [feedNames copy],
                       @"image": [UIImage imageNamed:@"button_add@2x.png"]
                     },
                     @{
                       @"title": @"Custom Feed",
                       @"items": @[@"Add a custom feed"],
                       @"image": [UIImage imageNamed:@"button_add@2x.png"]
                     }
                   ]);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Remove request operation and hide HUD
        __self.requestOperation = nil;
        [MBProgressHUD hideAllHUDsForView:__self.autoCompleteController.view animated:YES];
    
        __self.availableFeeds = nil;
    
        setDefaultList(@[
                         @{
                           @"title": @"Custom Feeds",
                           @"items": @[@"Add a custom feed"],
                           @"image": [UIImage imageNamed:@"button_add@2x.png"]
                         }
                       ]);
    
        //something went wrong
        NSLog(@"nooooooo");
    
        __self.requestOperation = nil;
  }];

  [_requestOperation start];
}

/**
 * Adds the selected feed to the users active feeds
 */
- (void)autoComplete:(CSAutoCompleteViewController *)viewController didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (self.availableFeeds && indexPath.section == 0)
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
        
        FeedSort *sort = [FeedSort createEntity];
        sort.user = currentUser;
        sort.feed = feed;
        
        [currentUser addFeedsObject:feed];
      }
      
      
      [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
      
      [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
      }];
  }
  else
  {
    [self showAddCustomFeedForm];
  }
}

/**
 * Cancels the add
 */
- (void)didPressCancelbuttonForAutoComplete:(CSAutoCompleteViewController *)viewController
{
  [self cancel:nil];
}


#pragma mark - Actions
/**
 * Shows the add/edit custom feed form
 */
- (void)showAddCustomFeedForm
{
  // Don't allow accidental double-creation
  if (_view_addCustomFeed) return;
  
  _view_addCustomFeed = [[UIView alloc] initWithFrame:CGRectMake(0, self.autoCompleteController.view.frame.size.height, self.autoCompleteController.view.frame.size.width, self.autoCompleteController.view.frame.size.height)];
  [_view_addCustomFeed setBackgroundColor:[UIColor colorWithRed:51/255.0 green:57/255.0 blue:75/255.0 alpha:1.0]];
  
  [_view_addCustomFeed setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
  
  _view_addCustomFeed.layer.masksToBounds = NO;
  _view_addCustomFeed.layer.shadowOffset = CGSizeMake(0, 0);
  _view_addCustomFeed.layer.shadowRadius = 3;
  _view_addCustomFeed.layer.shadowOpacity = 0.5;  
  _view_addCustomFeed.layer.shadowPath = [UIBezierPath bezierPathWithRect:_view_addCustomFeed.bounds].CGPath;
  
    
//  
  UIToolbar *toolbar_addCustomFeed = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.autoCompleteController.view.frame.size.width, 44)];
  [toolbar_addCustomFeed setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
  
  toolbar_addCustomFeed.layer.masksToBounds = NO;
  toolbar_addCustomFeed.layer.shadowOffset = CGSizeMake(0, 0);
  toolbar_addCustomFeed.layer.shadowRadius = 4;
  toolbar_addCustomFeed.layer.shadowOpacity = 0.4;
  toolbar_addCustomFeed.layer.shadowPath = [UIBezierPath bezierPathWithRect:toolbar_addCustomFeed.bounds].CGPath;

  
  NSMutableArray *barItems = [[NSMutableArray alloc] init];
  
  
  UIBarButtonItem *button_cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddCustomFeed)];
  [barItems addObject:button_cancel];
  
  UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
  [barItems addObject:flexSpace];
  
  
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 190, 44)];
  [label setBackgroundColor:[UIColor clearColor]];
  [label setTextColor:[UIColor whiteColor]];
  [label setFont:[UIFont fontWithName:@"Avenir-Medium" size:15.0]];
  [label setTextAlignment:NSTextAlignmentCenter];
  [label setText:@"Add Custom Feed"];
  
  
   
  UIBarButtonItem *labelItem = [[UIBarButtonItem alloc] initWithCustomView:label];
  [barItems addObject:labelItem];
  
  
  UIBarButtonItem *flexSpace2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
  [barItems addObject:flexSpace2];

  
  UIBarButtonItem *button_save = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveCustomFeed)];
  [barItems addObject:button_save];
  


  [toolbar_addCustomFeed setItems:barItems animated:YES];
  [_view_addCustomFeed addSubview:toolbar_addCustomFeed];
  
  
  UIImage *image_textFieldsBackground = [UIImage imageNamed:@"control_dualEntryTextField.png"];
  UIImageView *imageView_textFieldsBackground = [[UIImageView alloc] initWithImage:image_textFieldsBackground];
  
  UIView *view_TextInput = [[UIView alloc] initWithFrame:CGRectMake(self.autoCompleteController.view.frame.size.width/2 - 160, 50, 320, 180)];
  [view_TextInput setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
  
  [_view_addCustomFeed addSubview:view_TextInput];
  
  CGRect imageViewFrame = imageView_textFieldsBackground.frame;
  
  imageViewFrame.origin.y = 0;
  imageViewFrame.origin.x = 0;
//  imageViewFrame.size.width = view_TextInput.frame.size.width;
  
  [imageView_textFieldsBackground setFrame:imageViewFrame];
  
  [view_TextInput addSubview:imageView_textFieldsBackground];
  

  UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(imageViewFrame.size.width/2 - 170, imageViewFrame.origin.y + 15, 100, 28)];
  [labelName setText:@"Name:"];
  [labelName setBackgroundColor:[UIColor clearColor]];
  [labelName setFont:[UIFont fontWithName:@"Avenir-Black" size:12.0]];
  [labelName setTextColor:[UIColor colorWithWhite:.25 alpha:1.0]];
  [labelName setTextAlignment:NSTextAlignmentRight];
  
  UILabel *labelURL  = [[UILabel alloc] initWithFrame:CGRectMake(imageViewFrame.size.width/2 - 170, imageViewFrame.origin.y + 48, 100, 28)];
  [labelURL setText:@"Address:"];
  [labelURL setBackgroundColor:[UIColor clearColor]];
  [labelURL setFont:[UIFont fontWithName:@"Avenir-Black" size:12.0]];
  [labelURL setTextColor:[UIColor colorWithWhite:.25 alpha:1.0]];
  [labelURL setTextAlignment:NSTextAlignmentRight];
  
  [view_TextInput addSubview:labelName];
  [view_TextInput addSubview:labelURL];
  
  
  _textFieldName = [[UITextField alloc] initWithFrame:CGRectMake(labelName.frame.origin.x + labelName.frame.size.width + 10, imageViewFrame.origin.y + 20, 195, 25)];
  [_textFieldName setPlaceholder:@"Feed Name"];
  [_textFieldName setFont:[UIFont fontWithName:@"Avenir-Medium" size:13.0]];


  _textFieldURL  = [[UITextField alloc] initWithFrame:CGRectMake(labelURL.frame.origin.x + labelURL.frame.size.width + 10,   imageViewFrame.origin.y + 53, 195, 25)];
  [_textFieldURL setFont:[UIFont fontWithName:@"Avenir-Medium" size:13.0]];
  [_textFieldURL setPlaceholder:@"Feed URL"];
  [_textFieldURL setKeyboardType:UIKeyboardTypeURL];
  [_textFieldURL setAutocapitalizationType:UITextAutocapitalizationTypeNone];
  
  
  [view_TextInput addSubview:_textFieldName];
  [view_TextInput addSubview:_textFieldURL];
  
  
  // Show the view
  [self.autoCompleteController.view addSubview:_view_addCustomFeed];
  
  
  // Show this instantly if there is an edit feed
  CGFloat duration = .5;
  if (self.feed) duration = 0;
  
  [UIView animateWithDuration:duration animations:^{
    CGRect frame = _view_addCustomFeed.frame;
    frame.origin.y = 0;
    
    [_view_addCustomFeed setFrame:frame];
    //[_view_addCustomFeed setAlpha:1.0];
  } completion:^(BOOL finished) {
    [_textFieldName becomeFirstResponder];
  }];
  
}

/**
 * Closes the add/edit custom feed form
 */
- (void) cancelAddCustomFeed
{
  // Don't allow accidental double-removal
  if (!_view_addCustomFeed) return;
  
  // If there is a feed set dismiss the entire view controller
  if (self.feed)
  {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
      
    }];
    
    return;
  }
  
  // Slide the custom view form down
  [UIView animateWithDuration:0.5 animations:^{
    //[_view_addCustomFeed setAlpha:0.0];
    CGRect frame = _view_addCustomFeed.frame;
    frame.origin.y = 500;
    
    [_view_addCustomFeed setFrame:frame];
  } completion:^(BOOL finished) {
    [self.autoCompleteController.searchBar becomeFirstResponder];
    [_view_addCustomFeed removeFromSuperview];
    _view_addCustomFeed = nil;
  }];
}

/**
 * Saves 
 */
- (void)saveCustomFeed
{
  //
  // Check that the data is roughly valid
  //
  
  if ([_textFieldURL.text isEqualToString:@""] || [_textFieldName.text isEqualToString:@""])
  {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Your feed needs to have a name and a URL" delegate:nil cancelButtonTitle:@"I'll fix it" otherButtonTitles: nil] show];
    return;
  }
  
  if (!([[_textFieldURL.text substringWithRange:NSMakeRange(0, 7)] isEqualToString:@"http://"] || [[_textFieldURL.text substringWithRange:NSMakeRange(0, 8)] isEqualToString:@"https://"]))
  {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Feed addresses should start with http:// or https://" delegate:nil cancelButtonTitle:@"I'll fix it" otherButtonTitles: nil] show];
    return;
  }
  
  //
  // Save the feed
  //
  
  // Get the current user
  User *currentUser = [User current];

  if (self.feed)
  {
    // Save an existing feed
    self.feed.name = _textFieldName.text;
    self.feed.url = _textFieldURL.text;
  }
  else
  {
    // Make sure this feed isn't a duplicate
    for (Feed *currentFeed in currentUser.feeds)
    {
      if ([currentFeed.url isEqualToString:_textFieldURL.text])
      {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"You have already added this feed." delegate:nil cancelButtonTitle:@"I'll change it" otherButtonTitles:nil] show];
        return;
      }
    }
    
    // Create the new feed
    Feed *newFeed = [Feed createEntity];
    
    newFeed.name = _textFieldName.text;
    newFeed.url = _textFieldURL.text;
    
    FeedSort *sort = [FeedSort createEntity];
    sort.user = currentUser;
    sort.feed = newFeed;
    
    // Add the feed to the user and set it as active
    [[User current] addFeedsObject:newFeed];
  }
  
  // Save the data
  [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
  
  // Dismiss the controller
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}


#pragma mark - other

/**
 * Change autoCompleteController size on rotation
 */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  
  // Animate size adjustment for keyboard changes (overall frame will automatically resize after)
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
//                     NSLog(@"%f %f %f %f", self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
//                     NSLog(@"%f %f %f %f", self.autoCompleteController.view.frame.origin.x, self.autoCompleteController.view.frame.origin.y, self.autoCompleteController.view.frame.size.width, self.autoCompleteController.view.frame.size.height);
                     //NSLog(@"%f %f", self.view_addCustomFeed.frame.size.width, self.view_addCustomFeed.frame.size.height);
                   }
                   completion:^(BOOL finished){
                     NSLog(@"Done!");
                   }];  
}


#pragma mark - UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSLog(@"clicked %d", buttonIndex);
}


@end
