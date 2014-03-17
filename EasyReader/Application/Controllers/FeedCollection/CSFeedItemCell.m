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
    [self createGradientMaskForSummary];
}

- (void)createGradientMaskForSummary
{
    
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
