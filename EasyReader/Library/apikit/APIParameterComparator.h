//
//  APIParameterComparator.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/3/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * A collection of comparator methods for assisting in comparing api parameters
 */
@interface APIParameterComparator : NSObject

/**
 * Verifies that two sets of parameters match
 * If NSNull is specified for any key in parameters2 the comparison will be considered a match
 *
 * @param parameters1 The parameters dictionary to check
 * @param parameters2 The parameters dictionary to verify against
 */
+ (BOOL) compareParametersIgnoringNulls:(NSDictionary *)parameters1 toParameters:(NSDictionary *)parameters2;

/**
 * Verifies that two single parameters match
 * If NSNull is specified for parameter2 the comparison will be considered a match
 *
 * @param parameter1 The parameter to check
 * @param parameter2 The parameter to verify against
 */
+ (BOOL) compareParameterIgnoringNull:(id)parameter1 toParamteter:(id)parameter2;

/**
 * Verifies that two array parameters match
 * If NSNull is specified for parameter2 the comparison will be considered a match
 *
 * @param array1 The array to check
 * @param array2 The array to verify against
 */
+ (BOOL) compareArrayParameterIgnoringNull:(NSArray *)array1 toParameter:(NSArray *)array2;

@end
