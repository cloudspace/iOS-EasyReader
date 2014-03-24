//
//  UIColor+EZRSharedColorAdditions.h
//  EasyReader
//
//  Created by Michael Beattie on 3/24/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Extends UIColor to provide a set of standard colors used across the application
 */
@interface UIColor (EZRSharedColorAdditions)

+ (UIColor *) EZR_charcoal;
+ (UIColor *) EZR_charcoalWithOpacity:(float)opacity;

@end
