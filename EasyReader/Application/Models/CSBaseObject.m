//
//  CSBaseObject.m
//  EasyReader
//
//  Created by Alfredo Uribe on 3/12/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "CSBaseObject.h"

@implementation CSBaseObject

+ (id)createOrUpdateFirstFromAPIData:(NSDictionary *)remoteObjectData
{
    return [self createOrUpdateFirstFromAPIData:remoteObjectData byAttribute:@"id"];
}

/**
 * Looks up the first entity with it's [attribute] equal to [attribute] in remoteObjectData
 * If no object exists, create it
 *
 * @param baseObjectData A base dictionary of data to create the object from
 * @param byAttribute
 */
+ (id)createOrUpdateFirstFromAPIData:(NSDictionary *)baseObjectData byAttribute:(NSString *)attribute
{
    id object;
    
    if (baseObjectData != nil && attribute)
    {
        object = [self MR_findFirstByAttribute:attribute withValue:baseObjectData[attribute]];
        
        if (!object) object = [self MR_createEntity];
        
        [object updateWithAPIData:baseObjectData];
        
    }
    return object;
}


+ (NSDate *)dateFromAPIDateString:(NSString*)dateString
{
    // Ignore nil dates
    if (dateString == nil) return nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if ([dateString rangeOfString:@"T"].location == NSNotFound)
    {
        // Ain't nobody got time for that
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    else
    {
        // Date only
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss+00:00"];
    }
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    return [dateFormatter dateFromString:dateString];
}

- (void)updatePropertyWithName:(NSString *)name value:(NSDictionary *)value
{
    
}

- (void)setNSDatePropertyWithName:(NSString *)name value:(NSString *)value
{
    
}

- (void)updateWithAPIData:(NSDictionary *)userData
{
    NSArray *keys = [userData allKeys];
    
    // Checks each object property for corresponding API data
    [self reflectOverPropertyDataWithBlock:^(NSDictionary *propertyData) {
        NSString *underscoreKey = [propertyData[@"name"] underscore];
        NSString *key = propertyData[@"name"];
        NSString *type = propertyData[@"type"];
        
        if ([keys containsObject:underscoreKey] &&
            ![userData[underscoreKey] isKindOfClass:[NSNull class]] &&
            ![propertyData[@"readOnly"] boolValue])
        {
            if ([type isEqualToString:@"NSString"])
            {
                [self setValue:userData[underscoreKey] forKey:propertyData[@"name"]];
            }
            else if ([type isEqualToString:@"NSDate"])
            {
                [self setValue:[CSBaseObject dateFromAPIDateString:userData[underscoreKey]]
                        forKey:propertyData[@"name"]];
            }
            else if ([type isEqualToString:@"NSNumber"])
            {
                [self setValue:userData[underscoreKey] forKey:key];
            }
            else if ([type isEqualToString:@"NSSet"])
            {
                [self updateRelationshipWithName:key key:key data:userData[underscoreKey]];
            }
            else
            {
                [self updateRelationshipPropertyWithName:key key:key data:userData[underscoreKey]];
            }
        }
        else if([keys containsObject:underscoreKey] && [userData[underscoreKey] isKindOfClass:[NSNull class]])
        {
            
            [self setValue:nil forKey:key];
        }
    }];
}

- (void) updateRelationshipPropertyWithName:(NSString *)name key:(NSString *)key data:(id)data
{
    NSRelationshipDescription* rel = [[[self entity] relationshipsByName] valueForKey:key];
    NSString* className = [[rel destinationEntity] managedObjectClassName];
    
    Class klass = NSClassFromString(className);
    
    // Only continue if we're dealing with remote object descendants
    if (![klass isSubclassOfClass:[CSBaseObject class]]) return;
    
    //
    if (className && [data isKindOfClass:[NSDictionary class]])
    {
        [klass createOrUpdateFirstFromAPIData:data];
    }
    
}

- (void) updateRelationshipWithName:(NSString *)name key:(NSString *)key data:(id)data
{
    NSRelationshipDescription* rel = [[[self entity] relationshipsByName] valueForKey:key];
    NSString* className = [[rel destinationEntity] managedObjectClassName];
    
    Class klass = NSClassFromString(className);
    
    // Only continue if we're dealing with remote object descendants
    if (![klass isSubclassOfClass:[CSBaseObject class]]) return;
    
    //
    if (className && [data isKindOfClass:[NSArray class]])
    {
        // Remove all objects from the set
        [self setValue:nil forKey:key];
        
        // Repopulate with new info
        for (NSDictionary *nestedObjectData in data)
        {
            CSBaseObject *newObject = [klass createOrUpdateFirstFromAPIData:nestedObjectData];
            
            NSString *addMethodName = [[NSString stringWithFormat:@"add_%@_object:", [key underscore]] camelizeWithLowerFirstLetter];
            SEL addObjectSelector = NSSelectorFromString(addMethodName);
            
            if ([self respondsToSelector:addObjectSelector])
            {
                // does the same as perform selector but works around possible memory leak issues
                // see http://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
                
                IMP imp = [self methodForSelector:addObjectSelector];
                void (*func)(id, SEL, id) = (void *)imp;
                func(self, addObjectSelector, newObject);
            }
        }
    }
    else
    {
        NSLog(@"Error loading data for key %@", key);
    }
}

@end
