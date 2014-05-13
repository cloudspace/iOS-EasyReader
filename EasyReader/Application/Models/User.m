//
//  User.m
//  EasyReader
//
//  Created by Joseph Lorich on 4/9/13.
//  Copyright (c) 2013 Cloudspace. All rights reserved.
//

#import "User.h"
#import "Feed.h"
#import "FeedSort.h"

@implementation User

@dynamic feeds;
@dynamic activeFeed;
@dynamic feedSorts;


+ (User *)current
{
  NSArray *users = [User MR_findAll];
  
  if ([users count] > 0)
  {    
    return users[0];
  }
  else
  {
    User *user = [User MR_createEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    return user;
  }
}

@end
