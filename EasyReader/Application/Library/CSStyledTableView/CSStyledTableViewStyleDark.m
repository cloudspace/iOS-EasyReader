//
//  CSStyledTableViewStyleDark.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/16/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "CSStyledTableViewStyleDark.h"

@implementation CSStyledTableViewStyleDark

- (UIColor *)       tableBackgroundColor          { return [UIColor colorWithRed:51/255.0 green:58/255.0 blue:74/255.0 alpha:1.0]; }

//
// Header
//

- (UIColor *)       headerBackgroundTopColor      { return [UIColor colorWithRed:67/255.0 green:74/255.0 blue:94/255.0 alpha:1.0]; }
- (UIColor *)       headerBackgroundBottomColor   { return [UIColor colorWithRed:58/255.0 green:65/255.0 blue:83/255.0 alpha:1.0]; }

- (UIFont  *)       headerTitleLabelFont          { return [UIFont fontWithName:@"Avenir-Black" size:12.0f]; }
- (UIColor *)       headerTitleLabelTextColor     { return [UIColor colorWithWhite:0.90 alpha:1.0]; }
- (NSTextAlignment) headerTitleLabelTextAlignment { return NSTextAlignmentLeft; }

- (UIColor *)       headerLineTopColor1           { return [UIColor colorWithRed:41/255.0 green:48/255.0 blue:61/255.0 alpha:1.0]; }
- (UIColor *)       headerLineTopColor2           { return [UIColor colorWithRed:79/255.0 green:87/255.0 blue:103/255.0 alpha:1.0]; }
- (UIColor *)       headerLineBottomColor1        { return [UIColor colorWithRed:61/255.0 green:67/255.0 blue:79/255.0 alpha:1.0]; }
- (UIColor *)       headerLineBottomColor2        { return [UIColor colorWithRed:41/255.0 green:48/255.0 blue:61/255.0 alpha:1.0]; }


//
// Cell
//

// Background
- (UIColor *) cellBackgroundTopColor           { return [UIColor colorWithRed:51/255.0 green:58/255.0 blue:74/255.0 alpha:1.0]; }
- (UIColor *) cellBackgroundBottomColor        { return [UIColor colorWithRed:51/255.0 green:58/255.0 blue:74/255.0 alpha:1.0]; }
- (UIColor *) cellSeparatorColor               { return [UIColor colorWithRed:40/255.0 green:48/255.0 blue:59/255.0 alpha:1.0]; }


// Text Label
- (UIFont  *)       cellTextLabelFont          { return [UIFont fontWithName:@"Avenir-Medium" size:14.0f]; }
- (UIColor *)       cellTextLabelTextColor     { return [UIColor colorWithWhite:1.0 alpha:1.0]; }
- (NSTextAlignment) cellTextLabelTextAlignment { return NSTextAlignmentLeft; }

// Selection Style
- (UIColor *) cellSelectedBackgroundColor      { return [UIColor colorWithRed:39/255.0 green:45/255.0 blue:58/255.0 alpha:1.0]; }



@end
