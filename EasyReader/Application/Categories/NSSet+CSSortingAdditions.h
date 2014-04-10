//
//  NSSet+CSSortingAdditions.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSet (CSSortingAdditions)

/**
 * Sorts feeds alphabetically
 *
 * @param The set of feeds to sort
 */
- (NSArray *)sortedArrayByAttributes:(NSString *)attribute1,... NS_REQUIRES_NIL_TERMINATION;

@end
