//
//  NSSet+CSSortingAdditions.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "NSSet+CSSortingAdditions.h"

@implementation NSSet (CSSortingAdditions)

- (NSArray *)sortedArrayByAttributes:(NSString *)attribute1, ...
{
    NSMutableArray *descriptors = [[NSMutableArray alloc] init];
    
    if (attribute1)
    {
        [descriptors addObject:[NSSortDescriptor sortDescriptorWithKey:attribute1 ascending:YES]];
        
        va_list attributes;
        
        va_start(attributes, attribute1);
        
        NSString *attribute;
        
        while ((attribute = va_arg(attributes, NSString *)))
        {
            [descriptors addObject:[NSSortDescriptor sortDescriptorWithKey:attribute ascending:YES]];
        }
        
        va_end(attributes);
    }
    
    return [self sortedArrayUsingDescriptors:descriptors];
}

@end
