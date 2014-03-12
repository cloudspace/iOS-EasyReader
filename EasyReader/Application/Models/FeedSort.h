//
//  FeedSort.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/22/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CSBaseObject.h"

@class Feed, User;

@interface FeedSort : CSBaseObject

@property (nonatomic, retain) NSNumber * sortValue;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) Feed *feed;

@end
