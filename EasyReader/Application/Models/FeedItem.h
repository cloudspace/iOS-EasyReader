//
//  FeedItem.h
//  
//
//  Created by Michael Beattie on 3/11/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Feed;

@interface FeedItem : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * updatedAt;
@property (nonatomic, retain) NSString * publishedAt;
@property (nonatomic, retain) NSString * createdAt;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * externalID;
@property (nonatomic, retain) Feed *feed;

- (NSString *)getFeedName;
+ (NSString *)convertDateToTimeAgo:(NSString *)updatedAt;

@end
