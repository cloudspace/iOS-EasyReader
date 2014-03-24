//
//  NSObject+CSShortcuts.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/16/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

#define $equal(x,y) ((x && [x isEqual:y]) || (!x && !y))
#define $exists(x) (x != nil && ![x isKindOfClass:[NSNull class]] && x != NULL)

@interface NSObject (CSShortcuts)


- (BOOL) isNull;


@end
