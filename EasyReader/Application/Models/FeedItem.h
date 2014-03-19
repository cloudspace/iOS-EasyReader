//
//  FeedItem.h
//  
//
//  Created by Michael Beattie on 3/11/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CSBaseObject.h"

@class Feed;

@interface FeedItem : CSBaseObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSDate * publishedAt;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) Feed *feed;

- (NSString *)setHeadline;

@end
