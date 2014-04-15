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
 * @param attribute The first feed attribute to sort by
 * @param ... Additional attributes to sort by (nil terminated)
 */
- (NSArray *)sortedArrayByAttributes:(NSString *)attribute,... NS_REQUIRES_NIL_TERMINATION;

@end
