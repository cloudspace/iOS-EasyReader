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


#pragma mark - CSBaseObject -

/**
 * A base for NSManagedObjects that represent objects in a remote API object
 */
@interface CSBaseObject : NSManagedObject


#pragma mark - Instance creation from API Data helpers

/*
 * Creates or updates an object base on API data
 *
 * @param remoteObjectData the api data to update/create based on
 */
+ (id)createOrUpdateFirstFromAPIData:(NSDictionary *)remoteObjectData;


@end
