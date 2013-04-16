//
//  User.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/9/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "User.h"
#import "Feed.h"


@implementation User

@dynamic feeds;
@dynamic activeFeed;


+ (User *)current
{
  NSArray *users = [User findAll];
  
  if ([users count] > 0)
  {    
    return users[0];
  }
  else
  {
    User *user = [User createEntity];
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
    return user;
  }
}

@end
