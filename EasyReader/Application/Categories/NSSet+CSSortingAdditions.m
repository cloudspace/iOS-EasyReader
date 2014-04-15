//
//  NSSet+CSSortingAdditions.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "NSSet+CSSortingAdditions.h"

@implementation NSSet (CSSortingAdditions)

- (NSArray *)sortedArrayByAttributes:(NSString *)attribute, ...
{
    NSMutableArray *descriptors = [[NSMutableArray alloc] init];
    
    if (attribute)
    {
        [descriptors addObject:[NSSortDescriptor sortDescriptorWithKey:attribute ascending:YES]];
        
        va_list attributes;
        
        va_start(attributes, attribute);
        
        NSString *nextAttribute;
        
        while ((nextAttribute = va_arg(attributes, NSString *)))
        {
            [descriptors addObject:[NSSortDescriptor sortDescriptorWithKey:nextAttribute ascending:YES]];
        }
        
        va_end(attributes);
    }
    
    return [self sortedArrayUsingDescriptors:descriptors];
}

@end
