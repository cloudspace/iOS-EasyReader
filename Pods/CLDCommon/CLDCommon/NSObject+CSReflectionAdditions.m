//
//  NSObject+CSReflectionAdditions.m
//  EasyReader
//
//  Created by Alfredo Uribe on 3/12/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "NSObject+CSReflectionAdditions.h"
#import <objc/runtime.h>

#include <Foundation/Foundation.h>

@implementation NSObject (CSReflectionAdditions)

/**
 * Reflects on a objc_property_t getting it's type and name
 */
- (NSDictionary *) reflectionDataFromProperty:(objc_property_t)property {
  
  const char * name = property_getName(property);
  NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
  const char * type = property_getAttributes(property);
  
  NSString * typeString = [NSString stringWithUTF8String:type];
  NSArray * attributes = [typeString componentsSeparatedByString:@","];
  NSString * typeAttribute = [attributes objectAtIndex:0];
  NSString * propertyType = [typeAttribute substringFromIndex:1];
  BOOL readOnly = [attributes containsObject:@"R"];
  
  if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1) {
    propertyType = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];  //turns @"NSDate" into NSDate
  }
  
  return @{@"name": propertyName, @"type": propertyType, @"readOnly": [NSNumber numberWithBool:readOnly]};
}

/**
 * Reflects over an NSObject calling block once per property with a dictionary of information about that property
 */
- (void)reflectOverPropertyDataWithBlock:(void (^)(NSDictionary *propertyData))block
{
  unsigned int count;
  objc_property_t* properties = class_copyPropertyList([self class], &count);
  
  for (int i = 0; i < count; i++) {
    NSDictionary *propertyData = [self reflectionDataFromProperty:properties[i]];
    
    block(propertyData);
  }
  
  free(properties);
}

@end


