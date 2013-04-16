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
    
    // background view
    // selected background view
    // label
    // detail label
    // image
    
    //
    // Set background view
    //
    UIView *selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor: [style cellSelectedBackgroundColor]];
    self.selectedBackgroundView = selectedBackgroundView;
    
    //
    // Create a label to hold the text content, make the label fit relatively well in the frame
    //
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    [self.textLabel   setTextAlignment:[style cellTextLabelTextAlignment]];
    [self.textLabel            setFont:[style cellTextLabelFont]];
    [self.textLabel       setTextColor:[style cellTextLabelTextColor]];
    
  }
  return self;
}

- (void) layoutSubviews
{
  CGRect oldLabelFrame = self.textLabel.frame;
  CGRect oldImageFrame = self.imageView.frame;
  
  [super layoutSubviews];
  
  if (oldLabelFrame.size.width != 0) [self.textLabel setFrame:oldLabelFrame];
  if (oldImageFrame.size.width != 0) [self.imageView setFrame:oldImageFrame];
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
