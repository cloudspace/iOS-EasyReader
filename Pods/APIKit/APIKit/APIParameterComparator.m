//
//  APIParameterComparator.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/3/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "APIParameterComparator.h"

@implementation APIParameterComparator


+ (BOOL) compareParametersIgnoringNulls:(NSDictionary *)parameters1 toParameters:(NSDictionary *)parameters2 {
    NSMutableArray *checkedKeys = [NSMutableArray array];
    
    for (NSString *key in [parameters1 allKeys]) {
        id value1 = parameters1[key];
        id value2 = parameters2[key];
        
        if (![self compareParameterIgnoringNull:value1 toParamteter:value2]) {
            return NO;
        }
        
        [checkedKeys addObject:key];
    }
    
    for (NSString *key in [parameters2 allKeys]) {
        if (![checkedKeys containsObject:key]) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL) compareParameterIgnoringNull:(id)parameter1 toParamteter:(id)parameter2
{
    if (parameter2 == (id)[NSNull null]) {
        return YES;
    } else if ([parameter1 isKindOfClass:[NSArray class]]) {
        return [self compareArrayParameterIgnoringNull:parameter1 toParameter:parameter2];
    } else if ([parameter1 isKindOfClass:[NSDictionary class]]) {
        return [self compareParametersIgnoringNulls:parameter1 toParameters:parameter2];
    } else {
        return [parameter1 isEqual:parameter2];
    }
    
    return YES;
}

+ (BOOL) compareArrayParameterIgnoringNull:(NSArray *)array1 toParameter:(NSArray *)array2 {
    if ([array1 count] != [array2 count]) {
        return NO;
    }
    
    BOOL allFound = YES;
    
    NSMutableArray *mutableArray2 = [array2 mutableCopy];
    
    for (id value1 in array1) {
        BOOL found = NO;
        
        for (int i = 0; i < [mutableArray2 count]; i++) {
            if ([self compareParameterIgnoringNull:value1 toParamteter:mutableArray2[i]]) {
                found = YES;
                [mutableArray2 removeObjectAtIndex:i];
                break;
            }
        }
        
        if (!found) {
            allFound = NO;
            break;
        }
    }
    
    return allFound && [mutableArray2 count] == 0;
}

@end
