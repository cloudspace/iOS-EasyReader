//
//  FeedItemImage.h
//  EasyReader
//
//  Created by Jeremiah Hemphill on 3/18/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CSBaseObject.h"

@class FeedItem;

@interface FeedItemImage : CSBaseObject

@property (nonatomic, retain) NSString * iphoneRetina;
@property (nonatomic, retain) NSString * ipad;
@property (nonatomic, retain) NSString * ipadRetina;
@property (nonatomic, retain) FeedItem *feedItem;

@end
