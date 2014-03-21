//
//  CSAppDelegateService.m
//  EasyReader
//
//  Created by Joseph Lorich on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "SOApplicationDelegateService.h"


static NSMutableDictionary *sharedDispatchPredicates = nil;
static NSMutableDictionary *sharedInstances = nil;

static dispatch_once_t predicateDictionaryPredicate;
static dispatch_once_t instanceDictionaryPredicate;


@implementation SOApplicationDelegateService

/**
 * Returns a shared dictionary singleton used to store addresses of dispatch_once_t predicates
 * This allows for a per-class type dispatch_once
 */
+ (NSMutableDictionary *)sharedDispatchPredicates
{
    dispatch_once(&predicateDictionaryPredicate, ^{
        // Ensure we don't overwrite a manually set shared instance (useful in testing)
        if (sharedDispatchPredicates != nil) return;
        
        sharedDispatchPredicates = [[NSMutableDictionary alloc] init];
    });
    
    return sharedDispatchPredicates;
}

/**
 * 
 */
+ (NSMutableDictionary *)sharedInstances
{
    dispatch_once(&instanceDictionaryPredicate, ^{
        // Ensure we don't overwrite a manually set shared instance (useful in testing)
        if (sharedInstances != nil) return;
        
        sharedInstances = [[NSMutableDictionary alloc] init];
    });
    
    return sharedInstances;
}


/**
 *
 */
+ (SOApplicationDelegateService *)shared
{
    NSMutableDictionary *predicates = [self sharedDispatchPredicates];
    NSMutableDictionary *instances = [self sharedInstances];
    
    NSString *classString = NSStringFromClass([self class]);

    dispatch_once_t *pred;
    NSNumber *predicateAddress;
    
    if ([[predicates allKeys] containsObject:classString])
    {
        predicateAddress = [predicates valueForKey:classString];
        NSUInteger address = [predicateAddress unsignedIntegerValue];

        pred = (dispatch_once_t *)address;
    }
    else
    {
        // This class instance does not have a
        // Allocate new memory for this instance of pred
        pred = (long *)malloc(sizeof(long));
        *pred = 0;
        
        predicateAddress = [NSNumber numberWithUnsignedInteger:(NSUInteger)pred];
        
        [predicates setValue:predicateAddress forKey:classString];
    }

    dispatch_once(pred, ^{
        // Ensure we don't overwrite a manually set shared instance (useful in testing)
        id service = [instances valueForKey:classString];
        
        if (service) return;
        
        service = [[[self class] alloc] init];
        
        [instances setValue:service forKey:classString];
    });
    
    return [instances valueForKey:classString];
}

@end
