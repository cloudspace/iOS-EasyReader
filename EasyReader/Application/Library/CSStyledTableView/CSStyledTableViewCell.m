//
//  CSStyledTableViewCell.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSStyledTableViewCell.h"
#import "CSStyledTableViewStyle.h"

@implementation CSStyledTableViewCell

/**
 * Inits the view then sets the identifier
 */
- (id)initWithTableViewStyle:(CSStyledTableViewStyle *)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
  if (self)
  {
    self.tableViewStyle = style;
    
    // Set background view
    //
    self.backgroundView = [[UIView alloc] init];
    _gradientBackgroundLayer = [CAGradientLayer layer];
    _gradientBackgroundLayer.colors = [NSArray arrayWithObjects:(id)[[style cellBackgroundTopColor] CGColor], (id)[[style cellBackgroundBottomColor] CGColor], nil];
    [self.backgroundView.layer addSublayer:_gradientBackgroundLayer];

    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor: [style cellSelectedBackgroundColor]];
    self.selectedBackgroundView = selectedBackgroundView;

    
    //
    // Create a label to hold the text content, make the label fit relatively well in the frame
    //
    [self.textLabel      setBackgroundColor:[UIColor clearColor]];
    [self.textLabel        setTextAlignment:[style cellTextLabelTextAlignment]];
    [self.textLabel                 setFont:[style cellTextLabelFont]];
    [self.textLabel            setTextColor:[style cellTextLabelTextColor]];
    [self.textLabel setHighlightedTextColor:[style cellSelectedTextColor]];
    
    [self.imageView setClipsToBounds:YES];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    

    [self.textLabel setNumberOfLines:2];
  }
  return self;
}

- (void) layoutSubviews
{
  [super layoutSubviews];

  [_gradientBackgroundLayer setFrame:self.backgroundView.bounds];

  if (self.imageView.image)
  {
    [self.imageView setFrame:CGRectMake(5, 5, self.frame.size.height - 10, self.frame.size.height - 10)];
    [self.textLabel setFrame:CGRectMake(self.frame.size.height, 0, self.frame.size.width - (self.frame.size.height) - 30, self.frame.size.height)];
  }
  else
  {
    [self.textLabel setFrame:CGRectMake(15, 0, self.frame.size.width - 59, self.frame.size.height)];
  }
  
}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//   [super setSelected:selected animated:animated];
//   self.tableViewStyle
//  
//    // Configure the view for the selected state
//}

@end
