//
//  CSFeedItemCell.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedItemCell.h"

@implementation CSFeedItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self applyInfoGradient];
    [self applySummaryGradient];
}

- (void)applyInfoGradient
{
    // Create a new gradient object
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    // Set the dimensions equal to the info container
    gradient.frame = self.info_view.bounds;
    
    // Define and set array of gradient colors
    UIColor *lightColor = [UIColor colorWithRed:39/255.0f green:42/255.0f blue:44/255.0f alpha:0.7f];
    UIColor *mediumColor = [UIColor colorWithRed:39/255.0f green:42/255.0f blue:44/255.0f alpha:0.9f];
    UIColor *darkColor = [UIColor colorWithRed:39/255.0f green:41/255.0f blue:45/255.0f alpha:1.0f];
    gradient.colors = [NSArray arrayWithObjects:(id)[lightColor CGColor],(id)[mediumColor CGColor],(id)[darkColor CGColor],nil];
    
    // Define and set array of color stop positions
    NSNumber *stopLight = [NSNumber numberWithFloat:0.02];
    NSNumber *stopMedium = [NSNumber numberWithFloat:0.05];
    NSNumber *stopDark = [NSNumber numberWithFloat:0.1];
    gradient.locations = [NSArray arrayWithObjects:stopLight, stopMedium, stopDark, nil];
    
    // Apply the gradient
    [self.info_view.layer insertSublayer:gradient atIndex:0];
}

/**
 * Create and apply a gradient ask a mask to the feedItemSummary
 */
- (void)applySummaryGradient
{
    // Create a new gradient object
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    // Set the dimensions equal to the info container
    gradient.frame = self.label_summary.bounds;
    
    // Define and set array of gradient colors
    gradient.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor,nil];
    
    // Define and set array of color stop positions
    NSNumber *stopWhite = [NSNumber numberWithFloat:0.30];
    NSNumber *stopClear = [NSNumber numberWithFloat:0.90];
    gradient.locations = [NSArray arrayWithObjects:stopWhite, stopClear, nil];
    
    // Apply the gradient
    self.label_summary.layer.mask = gradient;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
