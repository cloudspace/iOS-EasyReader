//
//  CSFeedSearcher.h
//  EasyReader
//
//  Created by Michael Beattie on 3/20/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSFeedSearcher : NSObject

/**
 * API requestor for feeds similar to user input
 */
- (void)feedsLike:(NSString *)name;

@end
