//
//  CSEnhancedTableViewCell.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSEnhancedTableViewCell.h"
#import "CSEnhancedTableViewStyle.h"

@implementation CSEnhancedTableViewCell

/**
 * Inits the view then sets the identifier
 */
- (id)initWithTableViewStyle:(CSEnhancedTableViewStyle *)style reuseIdentifier:(NSString *)reuseIdentifier
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

  NSInteger textLabelWidthOffset = 0;
  NSInteger textLabelXOffset = 0;

  textLabelWidthOffset += self.imageView.image  ? self.frame.size.height : 0;
  textLabelWidthOffset += self.isEditing        ? 44 : 0;
  textLabelWidthOffset += self.showsReorderControl || self.accessoryType != UITableViewCellAccessoryNone ? 44 : 0;
  
  
  if (self.imageView.image)
  {
    [self.imageView setFrame:CGRectMake(5, 5, self.frame.size.height - 10, self.frame.size.height - 10)];
    textLabelXOffset += self.frame.size.height;
  }

  [self.textLabel setFrame:CGRectMake(15 + textLabelXOffset, 0, self.frame.size.width - 15 - textLabelWidthOffset, self.frame.size.height)];

  
}

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//  return [super gestureRecognizerShouldBegin:gestureRecognizer];
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
// return  [super gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//  return [super gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//  [super touchesBegan:touches withEvent:event];  //let the tableview handle cell selection
//  [self.nextResponder touchesBegan:touches withEvent:event]; // give the controller a chance for handling touch events
//}

//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//   [super setSelected:selected animated:animated];
//   self.tableViewStyle
//  
//    // Configure the view for the selected state
//}

@end
