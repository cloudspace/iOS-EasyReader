//
//  CSMenuUserFeedDataSource.h
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Feed, User, CSEnhancedTableView;

@interface CSMenuUserFeedDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, retain) NSMutableSet *feeds;

- (void)updateWithFeeds:(NSMutableSet *)feeds;

@end
