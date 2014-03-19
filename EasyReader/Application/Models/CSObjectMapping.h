//
//  CSObjectMapping.h
//  EasyReader
//
//  Created by Joseph Lorich on 3/18/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSObjectMapping : NSObject

/**
 * Builds a CSObjectMapping based on a dictionary
 */
+ (CSObjectMapping *)mappingWithDictionary:(NSDictionary *)mappingDictionary;

@end
