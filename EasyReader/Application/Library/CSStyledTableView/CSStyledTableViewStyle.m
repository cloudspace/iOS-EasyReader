//
//  CSTableViewStyle.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSStyledTableViewStyle.h"


@implementation CSStyledTableViewStyle

- (UIColor *)       tableBackgroundColor          { return [UIColor colorWithWhite:0.95 alpha:1.0]; }
//
// Header
//

- (UIColor *)       headerBackgroundTopColor      { return [UIColor colorWithWhite:.874f alpha:1.0]; }
- (UIColor *)       headerBackgroundBottomColor   { return [UIColor colorWithWhite:.905f alpha:1.0]; }

- (UIFont  *)       headerTitleLabelFont          { return [UIFont fontWithName:@"Avenir-Medium" size:13.0f]; }
- (UIColor *)       headerTitleLabelTextColor     { return [UIColor colorWithWhite:0.46 alpha:1.0]; }
- (NSTextAlignment) headerTitleLabelTextAlignment { return NSTextAlignmentCenter; }

- (UIColor *)       headerLineTopColor1           { return [UIColor colorWithWhite:214/255.0 alpha:1.0]; }
- (UIColor *)       headerLineTopColor2           { return [UIColor colorWithWhite:224/255.0 alpha:1.0]; }
- (UIColor *)       headerLineBottomColor1        { return [UIColor colorWithWhite:224/255.0 alpha:1.0]; }
- (UIColor *)       headerLineBottomColor2        { return [UIColor colorWithWhite:214/255.0 alpha:1.0]; }


//
// Cell
//

// Background
- (UIColor *) cellBackgroundTopColor           { return [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]; }
- (UIColor *) cellBackgroundBottomColor        { return [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]; }

- (UIColor *) cellSeparatorColor               { return [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]; }

// Text Label
- (UIFont  *)       cellTextLabelFont          { return [UIFont fontWithName:@"Avenir-Heavy" size:13.0]; }
- (UIColor *)       cellTextLabelTextColor     { return [UIColor colorWithWhite:65/255.0 alpha:1.0]; }
- (NSTextAlignment) cellTextLabelTextAlignment { return NSTextAlignmentLeft; }

// Selection Style
- (UIColor *) cellSelectedBackgroundColor      { return [UIColor colorWithRed:185/255.0 green:200/255.0 blue:220/255.0 alpha:1.0]; }
- (UIColor *)       cellSelectedTextColor      { return [self cellTextLabelTextColor];}

@end
