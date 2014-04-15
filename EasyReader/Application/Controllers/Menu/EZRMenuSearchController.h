//
//  EZRMenuSearchBarDelegate.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Acts as the delegate object for the menu search bar
 */
@interface EZRMenuSearchController : NSObject <UISearchBarDelegate>

/**
 * Cancels a search, clears the search text, hides the keyboard
 */
- (void)cancelSearch;

@end
