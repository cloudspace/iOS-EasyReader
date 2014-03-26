//
//  CSFeedItemCell.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/17/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSFeedItemCell.h"
#import "UIColor+EZRSharedColorAdditions.h"

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
    [self.info_view setBackgroundColor:[UIColor clearColor]];
    
    // Create a new gradient object
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    // Set the dimensions equal to the info container
    gradient.frame = self.info_view.bounds;
    
    // Define and set array of gradient colors
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor EZR_charcoalWithOpacity:0.7] CGColor],
                                                (id)[[UIColor EZR_charcoalWithOpacity:0.9] CGColor],
                                                (id)[[UIColor EZR_charcoal] CGColor],nil];
    
    // Define and set array of color stop positions
    gradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.02],
                                                   [NSNumber numberWithFloat:0.05],
                                                   [NSNumber numberWithFloat:0.1], nil];
    
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
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor clearColor] CGColor],nil];
    
    // Define and set array of color stop positions
    gradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.30],
                                                   [NSNumber numberWithFloat:0.90], nil];
    
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
