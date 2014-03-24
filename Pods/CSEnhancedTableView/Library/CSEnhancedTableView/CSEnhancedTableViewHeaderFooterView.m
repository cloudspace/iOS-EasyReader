//
//  CSEnhancedTableViewHeaderFooterView.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSEnhancedTableViewHeaderFooterView.h"
#import "CSEnhancedTableViewStyle.h"
#import <QuartzCore/QuartzCore.h>

@implementation CSEnhancedTableViewHeaderFooterView

/**
 * Inits the view then sets the identifier
 */
- (id) initWithTableViewStyle:(CSEnhancedTableViewStyle *)style ReuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithReuseIdentifier:reuseIdentifier];
  
  if (self)
  {
    self.tableViewStyle = style;
    
    _gradientBackgroundLayer = [CAGradientLayer layer];
    _gradientBackgroundLayer.colors = [NSArray arrayWithObjects:(id)[[style headerBackgroundTopColor] CGColor], (id)[[style headerBackgroundBottomColor] CGColor], nil];
    [self.backgroundView.layer addSublayer:_gradientBackgroundLayer];

    
    //
    // Add label to header
    //
    
    // Create a label to hold the text content
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor =  [UIColor clearColor];
    [_titleLabel setTextAlignment: [style headerTitleLabelTextAlignment]];
    [_titleLabel setFont:          [style headerTitleLabelFont]];
    [_titleLabel setTextColor:     [style headerTitleLabelTextColor]];
    
    [self.textLabel setHidden:YES];
    
    [self.contentView addSubview:_titleLabel];
    
    //
    // Add Line Views
    //
    
    _lineViewTop1 = [[UIView alloc] init];
    _lineViewTop1.backgroundColor = [style headerLineTopColor1];
    [self.contentView addSubview:_lineViewTop1];
    
    _lineViewTop2 = [[UIView alloc] init];
    _lineViewTop2.backgroundColor = [style headerLineTopColor2];
    [self.contentView addSubview:_lineViewTop2];
    
    _lineViewBottom1 = [[UIView alloc] init];
    _lineViewBottom1.backgroundColor = [style headerLineBottomColor1];
    [self.contentView addSubview:_lineViewBottom1];
    
    _lineViewBottom2 = [[UIView alloc] init];
    _lineViewBottom2.backgroundColor = [style headerLineBottomColor2];
    [self.contentView addSubview:_lineViewBottom2];
    
   
  }
  
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  [_gradientBackgroundLayer setFrame:self.backgroundView.bounds];

  [_lineViewTop1    setFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
  [_lineViewTop2    setFrame:CGRectMake(0, 1, self.frame.size.width, 1)];
  [_lineViewBottom1 setFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
  [_lineViewBottom2 setFrame:CGRectMake(0, self.frame.size.height,   self.frame.size.width, 1)];
  
  [_titleLabel      setFrame:CGRectMake(15,
                                         0,
                                         self.frame.size.width - 15,
                                         self.frame.size.height)];
}
@end
