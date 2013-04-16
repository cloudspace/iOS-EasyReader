//
//  CSFeedItemView.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/5/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSFeedItemView.h"
#import <QuartzCore/QuartzCore.h>
#import "MTLabel.h"


@implementation CSFeedItemView

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (self) {
    //
    // label_title
    //
    self.label_title = [[MTLabel alloc] init];
    [self.label_title setFont:[UIFont fontWithName:@"Avenir-Heavy" size:13.0]];
    [self.label_title setFontColor:[UIColor colorWithWhite:65/255.0 alpha:1.0]];
    [self.label_title setLineHeight:14];
    [self.label_title setLimitToNumberOfLines:1];
    
    //
    // label_description
    //
    self.label_description = [[MTLabel alloc] init];
    [self.label_description setFont:[UIFont fontWithName:@"Avenir-Medium" size:12.0]];
    [self.label_description setFontColor:[UIColor colorWithWhite:167/255.0 alpha:1.0]];
    
    //
    // Image View
    //
    //self.imageView_image = [[UIImageView alloc] init];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.imageView setClipsToBounds:YES];
    
    //146,260,174
    // self
    //
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    
    UIView *backgroundColorView = [[UIView alloc] init];
    [backgroundColorView setBackgroundColor:[UIColor colorWithRed:185/255.0 green:200/255.0 blue:220/255.0 alpha:1.0]];
    [self setSelectedBackgroundView:backgroundColorView];
    
    //
    // Subviews
    //
    [self.contentView addSubview:self.label_title];
    [self.contentView addSubview:self.label_description];
    [self.contentView addSubview:self.imageView_image];
  }
  
  return self;
}

// Sets up the frames based on the content
- (void)layoutSubviews
{
  //
  // Default
  //
  NSInteger cellWidth = self.frame.size.width;
  
  if (!self.imageView.hidden)
  {
    [self.label_title setFrame:CGRectMake(50, 5, cellWidth-75, 30)];
    [self.imageView setFrame:CGRectMake(5, 5, 40, 40)];
  }
  else
  {
    [self.label_title setFrame:CGRectMake(10, 5, cellWidth-35, 30)];
  }
  
  [self.label_title setNeedsDisplay];
//  [self.label_description setFrame:CGRectMake(50, 25, 245, 20)];
  
  [self.selectedBackgroundView setFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
  
}

@end
