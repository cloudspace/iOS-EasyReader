//
//  CSBaseObject.h
//  EasyReader
//
//  Created by Alfredo Uribe on 3/12/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NSObject+CSReflectionAdditions.h"
#import "NSObject+CSNilAdditions.h"
#import "NSString+Inflections.h"

@interface CSBaseObject : NSManagedObject
+ (id)createOrUpdateFirstFromAPIData:(NSDictionary *)remoteObjectData;

@end
