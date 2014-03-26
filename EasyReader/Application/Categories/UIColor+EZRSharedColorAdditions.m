//
//  UIColor+EZRSharedColorAdditions.m
//  EasyReader
//
//  Created by Michael Beattie on 3/24/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "UIColor+EZRSharedColorAdditions.h"

@implementation UIColor (EZRSharedColorAdditions)

#pragma mark - Color Methods

+ (UIColor *) EZR_menuBackground           { return [UIColor colorWithRed:51/255.0 green:58/255.0 blue:74/255.0 alpha:1.0]; }
+ (UIColor *) EZR_menuInputBackground      { return [UIColor colorWithRed:67/255.0 green:74/255.0 blue:94/255.0 alpha:1.0]; }

+ (UIColor *) EZR_charcoal                 { return [UIColor EZR_charcoalWithOpacity:1]; }
+ (UIColor *) EZR_charcoalWithOpacity:(float)opacity {
    return [UIColor colorWithRed:39/255.0f green:42/255.0f blue:44/255.0f alpha:opacity];
}

@end
