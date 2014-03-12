//
//  NSObject+CSNilAdditions.h
//  EasyReader
//
//  Created by Alfredo Uribe on 3/12/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A set of methods to help in checking if an object is empty, nil, null, NSNull
 */
@interface NSObject (CSNilAdditions)

/**
 * Checks if the given object is blank
 *
 * @param object The object to check for blankness
 * @return true if nil, null, NSNull, or is an empty NSString, NSSet, or NSArray
 */
+ (BOOL)isBlank:(id)object;

/**
 * Checks if this object is blank
 * @return true if nil, null, NSNull, or is an empty NSString, NSSet, or NSArray
 */
- (BOOL)isBlank;

@end
