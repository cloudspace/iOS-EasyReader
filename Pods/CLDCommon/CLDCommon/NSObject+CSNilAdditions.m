//
//  NSObject+CSNilAdditions.m
//  EasyReader
//
//  Created by Alfredo Uribe on 3/12/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import "NSObject+CSNilAdditions.h"

@implementation NSObject (CSNilAdditions)

+ (BOOL)isBlank:(id)object {
  if ([object isKindOfClass:[NSSet class]] || [object isKindOfClass:[NSArray class]])
  {
    return [object count] == 0;
    
  }
  else if ([object isKindOfClass:[NSString class]])
  {
    return [object length] == 0;
  }
  else
  {
    return !object || (object == (id)[NSNull null]);
  }
}

- (BOOL)isBlank {
  return [NSObject isBlank:self];
}

@end
