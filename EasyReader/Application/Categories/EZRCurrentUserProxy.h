//
//  EZRCurrentUserProxy.h
//  EasyReader
//
//  Created by Joseph Lorich on 4/10/14.
//  Copyright (c) 2014 Cloudspace. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

/**
 * A proxy class that references the current user
 */
@interface EZRCurrentUserProxy : NSObject

/// The current user
@property (nonatomic, retain) User *user;


@end
