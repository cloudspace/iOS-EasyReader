//
//  NSObject+CSReflectionAdditions.h
//  EasyReader
//
//  Created by Alfredo Uribe on 3/12/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A collection of methods to assist with reflection
 */
@interface NSObject (CSReflectionAdditions)


/**
 * Reflects over an NSObject calling block once per property with a dictionary of information about that property
 *
 * @param block the block that will get called once per property with the property info
 */
- (void)reflectOverPropertyDataWithBlock:(void (^)(NSDictionary *propertyData))block;


@end
