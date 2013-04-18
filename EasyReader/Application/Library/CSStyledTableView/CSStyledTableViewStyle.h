//
//  CSTableViewStyle.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CSTableViewStyle <NSObject>

@optional
- (UIColor *)       tableBackgroundColor;

//
// Header
//
- (UIColor *)       headerBackgroundColor;
- (UIColor *)       headerBackgroundTopColor;
- (UIColor *)       headerBackgroundBottomColor;


- (UIFont  *)       headerTitleLabelFont;
- (UIColor *)       headerTitleLabelTextColor;
- (NSTextAlignment) headerTitleLabelTextAlignment;
- (CGFloat)         headerTitleLabelLeftPadding;

- (UIColor *)       headerLineTopColor1;
- (UIColor *)       headerLineTopColor2;
- (UIColor *)       headerLineBottomColor1;
- (UIColor *)       headerLineBottomColor2;


//
// Cell
//

// Background
- (UIColor *)       cellBackgroundColor;
- (UIColor *)       cellBackgroundTopColor;
- (UIColor *)       cellBackgroundBottomColor;

// Text Label
- (UIFont  *)       cellTextLabelFont;
- (UIColor *)       cellTextLabelTextColor;
- (NSTextAlignment) cellTextLabelTextAlignment;

// Selection
- (UIColor *)       cellSelectedBackgroundColor;
- (UIColor *)       cellSelectedTextColor;
- (UIColor *)       cellSeparatorColor;


@end

@interface CSStyledTableViewStyle : NSObject <CSTableViewStyle>


@end
