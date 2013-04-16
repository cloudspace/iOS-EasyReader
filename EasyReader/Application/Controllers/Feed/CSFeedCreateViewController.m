//
//  CSFeedCreateViewController.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/9/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSFeedCreateViewController.h"
#import  "CSRootViewController.h"
#import "MFSideMenu.h"

#import "Feed.h"
#import "User.h"

@implementation CSFeedCreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  
  if (self)
  {
    // Cancel button
    self.barButton_cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(cancel:)
                             ];
    self.navigationItem.leftBarButtonItem = self.barButton_cancel;
    
    // Save button
    self.barButton_save = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                             style:UIBarButtonItemStyleBordered
                                                            target:self
                                                            action:@selector(save:)
                             ];
    self.navigationItem.rightBarButtonItem = self.barButton_save;
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
  
//  [self.rootViewController.sideMenu setMenuState:MFSideMenuStateLeftMenuOpen];
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
}
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
