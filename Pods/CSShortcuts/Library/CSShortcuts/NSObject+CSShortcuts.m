//
//  NSObject+CSShortcuts.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/16/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "NSObject+CSShortcuts.h"

@implementation NSObject (CSShortcuts)


- (BOOL) isNull
{
  if ([self isKindOfClass:[NSNull class]])
  {
    return YES;
  }
  else
  {
    return NO;
  }
}


@end
