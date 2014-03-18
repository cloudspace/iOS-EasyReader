//
//  FeedItem.h
//  EasyReader
//
//  Created by Jeremiah Hemphill on 3/18/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CSBaseObject.h"

@class Feed, FeedItemImage;

@interface FeedItem : CSBaseObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * publishedAt;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Feed *feed;
@property (nonatomic, retain) FeedItemImage *images;

- (NSString *)getFeedName;
+ (NSString *)convertDateToTimeAgo:(NSDate *)updatedAt;

@end
