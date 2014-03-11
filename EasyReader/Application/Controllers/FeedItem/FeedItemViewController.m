//
//  FeedItemViewController.m
//  
//
//  Created by Michael Beattie on 3/6/14.
//
//

#import "FeedItemViewController.h"

@interface FeedItemViewController ()

@end

@implementation FeedItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    // Add the gradient to the feedItemInfoContainer
    [self applyGradient];
  
    // Set the feed item fields
    [self setFeedItemInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// This will take a param of FeedItem
- (void)setFeedItemInfo
{
  [self setFeedNameAndDate];
  [self setFeedItemHeader];
  [self setFeedItemSmummary];
  [self setFeedItemImage];
}

- (void)setFeedNameAndDate
{
  // takes in a string and a date
  // converts date to time since
  // format and set the feedName
}

- (void)setFeedItemHeader
{
  // takes in a string
  // sets the feedItemHeadline
}

- (void)setFeedItemSmummary
{
  // takes in a string
  // sets the feedItemSummary
}

- (void)setFeedItemImage
{
  // takes in a image resource
  // sets the feedItemImage
}

- (void)applyGradient
{
  // Create a new gradient object
  CAGradientLayer *gradient = [CAGradientLayer layer];
  
  // Set the dimensions equal to the info container
  gradient.frame = self.feedItemInfoContainer.bounds;
  
  // Create three colors with varying opacity
  UIColor *lightColor = [UIColor colorWithRed:39/255.0f green:42/255.0f blue:44/255.0f alpha:0.7f];
  UIColor *mediumColor = [UIColor colorWithRed:39/255.0f green:42/255.0f blue:44/255.0f alpha:0.9f];
  UIColor *darkColor = [UIColor colorWithRed:39/255.0f green:41/255.0f blue:45/255.0f alpha:1.0f];
  
  // Create array of colors to form gradient
  gradient.colors = [NSArray arrayWithObjects:(id)[lightColor CGColor],(id)[mediumColor CGColor],(id)[darkColor CGColor],(id)[darkColor CGColor],(id)[darkColor CGColor],(id)[darkColor CGColor],(id)[darkColor CGColor],(id)[darkColor CGColor],(id)[darkColor CGColor], nil];
  
  // Apply the gradient
  [self.feedItemInfoContainer.layer insertSublayer:gradient atIndex:0];
}

@end
