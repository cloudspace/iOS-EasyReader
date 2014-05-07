//
//  EZRSearchBar.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * A Search Bar with text field customization availability
 */
@interface EZRSearchBar : UISearchBar


/// The UITextField inside the search bar
@property (nonatomic, readonly) UITextField *textField;


@end
