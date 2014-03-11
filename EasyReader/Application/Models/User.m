//
//  User.m
//  
//
//  Created by Michael Beattie on 3/11/14.
//
//

#import "User.h"
#import "Feed.h"


@implementation User

@dynamic feeds;

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
