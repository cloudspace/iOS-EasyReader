//
//  CSObjectMapping.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/18/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSObjectMapping.h"

@implementation CSObjectMapping
{
    /// The internal dictionary to hold all key-value mappings
    NSDictionary *_mapping;
}

/**
 * Inits a mapping dictionary
 *
 * @param mappingDictionary A key-value mapping dictionary
 */
- (id)initWithMappingDictionary:(NSDictionary *)mapping
{
    self = [super init];
    
    _mapping = mapping;
    return self;
}

/**
 * Builds a CSMappingObject
 *
 * @param mappingDictionary A key-value mapping dictionary
 */
+ (CSObjectMapping *) mappingWithDictionary:(NSDictionary *)mappingDictionary
{
    return [[CSObjectMapping alloc] initWithMappingDictionary:mappingDictionary];
}

/**
 * Returns the appropriate key on the local object for the given mapped key
 *
 * @param mappedKey the string used to look up the key on the local object
 */
- (NSString *)objectKeyForString:(NSString *)mappedKey
{
    if ([[_mapping allKeys] containsObject:mappedKey])
    {
        return _mapping[mappedKey];
    }
    else
    {
        return nil;
    }
}

@end
