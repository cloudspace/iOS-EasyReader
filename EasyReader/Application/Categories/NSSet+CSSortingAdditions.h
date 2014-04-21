//
//  NSSet+CSSortingAdditions.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Additions to NSSet to allow sorting by attribute names
 */
@interface NSSet (CSSortingAdditions)

/**
 * Sorts feeds alphabetically
 *
 * @param attribute The attributes to sort by
 * @param ascending Whether or not the array should be sorted in ascending order
 */
- (NSArray *)sortedArrayByAttributes:(NSArray *)attributes ascending:(BOOL)ascending;

@end
