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
#import "APIClient.h"


#pragma mark - CSBaseObject

/**
 * A base for NSManagedObjects that represent objects in a remote API object
 */
@interface APIRemoteObject : NSManagedObject

#pragma mark - Instance creation from API Data helpers

/**
 * Creates or updates an object base on API data
 *
 * @param remoteObjectData the api data to update/create based on
 */
+ (id)createOrUpdateFirstFromAPIData:(NSDictionary *)remoteObjectData;


/**
 * Parses an NSDate out of an api date string
 *
 * @param dateString the api date string to parse
 */
+ (NSDate *)dateFromAPIDateString:(NSString*)dateString;

#pragma mark - API Client access helpers

/// Returns a shared singleton API client for this object
@property (nonatomic, readonly) APIClient *client;

/**
 * Returns a shared singleton API Client for this class
 */
+ (APIClient *)client;

@end
