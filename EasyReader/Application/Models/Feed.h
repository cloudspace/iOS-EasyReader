//
//  Feed.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/9/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Feed, User;

@interface Feed : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * iconURL;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) User *isActiveFor;

@end
